# working notes / dev diary

hey who knows, maybe some of this will be useful for someone else learning to hack at Atom / grammars / etc

# Table of Contents

hashtag dogfooding

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [working notes](#working-notes)
- [Table of Contents](#table-of-contents)
	- [some semblance of a plan?](#some-semblance-of-a-plan)
		- [rewrite the header detection to use Atom and not just futz with text](#rewrite-the-header-detection-to-use-atom-and-not-just-futz-with-text)
		- [refactor so we don't get weird behavior](#refactor-so-we-dont-get-weird-behavior)
			- [ideas:](#ideas)
				- [todo list ideas](#todo-list-ideas)
	- [Get grammar info](#get-grammar-info)
		- [line-by-line tokenizing? didn't work the first time around](#line-by-line-tokenizing-didnt-work-the-first-time-around)
		- [what's the tokenized text object look like?](#whats-the-tokenized-text-object-look-like)
	- [Here's what I'm parsing for to find where to put the TOC](#heres-what-im-parsing-for-to-find-where-to-put-the-toc)

<!-- /TOC -->

## ok so what's the problem?
Well, two problems, and they're short ones:
1. There aren't many good markdown tools out there, and
2. even the most popular one appears to have been mostly about getting it working. (Sorry Nok, no offense intended. )

But, what's up with markdown-toc?

### markdown-toc does its own text parsing
It takes in the text buffer, finds stuff that looks like headers, and off we go.
But Atom provides all this meta info from the grammar, why are we not using it? We're not aware of comment blocks, or context of any sort. We can't do anything cool like subsection TOCs or whatnot

### the uhhh architecture? design? format? framework? (idk i'm not a developer)
Original was inconsistently working -
- atom-local variables instead of editor-local meant reparsing every time.
- closing the editor/file and reopening meant having to delete the TOC tag & reactivate.
- could only be 'active' on one markdown file at a time i think

- I tried to improve it but my first PR had weird behavior when multiple markdown docs were open.  
  - again tho, not a developer.
	- but i am onto something with the weird scoping and stuff tho, right?

## ATOM HAS NO DEV BEST PRACTICES GUIDE
Guess i should think about getting the idea out there, eh?  Plus side: it's 800% ok to get it wrong since nobody's bothered yet!

## refactor plan
How do we solve this? idk, probably a rewrite?

### Package architecture
- Init: On atom load? Get it into the packages menu so you can add the tag.
	- TODO: answer init questions

#### Atom-global stuff
  - TOC/markdown file setup event subscriptions
	- Menu items

#### Editor-level stuff
  - Subscribe to grammar changes so we can be ready as soon as markdown's detected?

#### Atom Event subscriptions
  - Editor:
		- observeGrammar (set up TOC stuff in individual file.)
  - Buffer:
	  - onWillSave (autoupdate on save)
		- onDidReload (re-read the file TOC)
		- onDidChange or onDidStopChanging (live-update)


#### keep TOC in memory, per buffer.
Doesn't require much mem really.  Should be quick to rebuild on load. (Worth testing?)

##### Object format

### keybindings?
no. go away.  Dropdown menu lets you paste in a TOC header, off you go. Keybindings are for shit you do more than once.

* Caveat: if I get out over my skis and add more markdown functions, have at.

#### ideas:
- package itself should be workspace-local and not editor- or buffer-local
  - joke's on you, I have no idea what best practice is yet
- where's the per-file object best to be put? editor? buffer?
  - do we hold it in memory, or do we re-parse every save?
  - well, what's the object look like?
    - TOC array
- TOC header should auto-update to include all available options, yeah?
  - delete one to reset it to default? nice.

##### todo list ideas
- live-update? what's the perf penalty? can we minimize enough to make it worth it?
- subsection TOCs for big files if you're a masochist i suppose
- Option for including "Table of Contents" heading within the TOC tag? that'd be neat.
- any other markdown-specific stuff that might be handy?
  - is it worth subsuming a bunch of other markdown one-offs?
    - idk but i like the idea of providing a bit more help
    - what's the 'penalty' for renaming an atom package once it's published?
    - i ain't rewriting _more_ shit, gotta make sure everyone's properly credited if i do.


## Learning shit
Here's where I'm learning how Atom works.  More or less in chronological order?

### Atom behavior/organization

#### Init questions

##### Package
- How early do we start up?
  - I mean initial setup should probably be at the start, so it's surfaced in the Packages dropdown menu from the get-go.
	  - Legit reasons why we wouldn't do that?  (Only on first markdown file? ehhhhh)
- How does Atom's startup deal with already-open files?
  - This changes how we choose to init down the line. If while-running file opens get the same events as atom-startup file opens, no need for a special case.

##### File
One file can have multiple editors (same buffer, different views.)  The TOC object itself should probably be scoped here, even though we need Editor events/info like Grammars.

- Do we attach an object to each markdown Editor to help manipulate?

#### Editing the file:
From the [API docs for TextEditor](https://atom.io/docs/api/v1.35.1/TextEditor):
> Your choice of coordinates systems will depend on what you're trying to achieve. For example, if you're writing a command that jumps the cursor up or down by 10 lines, you'll want to use screen coordinates because the user probably wants to skip lines on screen. However, if you're writing a package that jumps between method definitions, you'll want to work in buffer coordinates.

So we'll start with the buffer coords.  (Can I reliably keep track of the TOC location? stay tuned)

### Get grammar info

Open the dev tools.
While in a markdown edit buffer:
```
thisEditor=atom.workspace.getActiveTextEditor()
thisGrammar=thisEditor.getGrammar()
tokenizedText=thisEditor.getGrammar().tokenizeLines(thisEditor.buffer.cachedText)
```

#### line-by-line tokenizing? didn't work the first time around
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

#### what's the tokenized text object look like?
tokenizedText:
- Array of Lines
  - Lines are arrays of tokens, which are objects containing
    - value: text of the token
    - scopes: array of applicable scopes (as strings) within the grammar
      - ex: "comment.block.gfm", "markup.heading.heading-4.gfm"

#### Here's what I'm parsing for to find where to put the TOC

TOC opener:
not sure yet if we can rely on exactly these scopes but both should be there.
```
Scopes: ["source.gfm","comment.block.gfm"]
Value: " TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 "
```

TOC Closer:
```
Scopes: ["source.gfm","comment.block.gfm"]
Value: " /TOC "
```
