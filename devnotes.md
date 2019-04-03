# working notes

hey who knows, maybe some of this will be useful for someone else learning to hack at Atom / grammars / etc

## some semblance of a plan?

### rewrite the header detection to use Atom and not just futz with text
We've got all this meta info from the grammar, why are we not using it? We're not aware of comment blocks, or context of any sort. We can't do anything cool like subsection TOCs or whatnot

### refactor so we don't get weird behavior
original was inconsistently working at all
my first PR had weird behavior when multiple markdown docs were open.  

#### ideas:
- package itself should be workspace-local and not editor- or buffer-local
  - joke's on you, I have no idea what best practice is yet
- where's the per-file object best to be put? editor? buffer?
  - do we hold it in memory, or do we re-parse every save?
  - well, what's the object look like?
    - TOC array
      - string of actual toc line
      - pointers to original lines (for liveUpdate?)

##### todo list ideas
- live-update? what's the perf penalty? can we minimize enough to make it worth it?
- subsection TOCs for big files if you're a masochist i suppose

## Get grammar info

Open the dev tools.
While in a markdown edit buffer:
```
thisEditor=atom.workspace.getActiveTextEditor()
thisGrammar=thisEditor.getGrammar()
tokenizedText=thisEditor.getGrammar().tokenizeLines(thisEditor.buffer.cachedText)
```

### line-by-line tokenizing? didn't work the first time around
Tokenizing line-by-line got frustrating:
```
textAsArray=thisEditor.buffer.getLines()
ruleStack=[thisGrammar.getInitialRule()]
thisGrammar.tokenizeLine()
```
API docs say ruleStack is an array of rules, but it's an array of objects _containing_ rules. bah.
- contentScopeName: undefined in the one i tried, string possibly?
- `rule` object, same as getInitialRule() & initialRule
- scopeName: on first rule, just the base ("source.gfm" in the case of github's markup.)

Here's the ugly way to get it working:
```
ruleStack=thisGrammar.tokenizeLine("").ruleStack
thisGrammar.tokenizeLine(textAsArray[0],ruleStack,true)
```
but like why should i have to tokenize anything first to get it working? grammar obj already has `initialRule` and `getInitialRule()`

### what's the tokenized text object look like?
tokenizedText:
- Array of Lines
  - Lines are arrays of tokens, which are objects containing
    - value: text of the token
    - scopes: array of applicable scopes (as strings) within the grammar
      - ex: "comment.block.gfm", "markup.heading.heading-4.gfm"

## Here's what I'm parsing for to find where to put the TOC

TOC opener:
Scopes: ["source.gfm","comment.block.gfm"]
Value: " TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 "

TOC Closer:
Scopes: ["source.gfm","comment.block.gfm"]
" /TOC "
