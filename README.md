Markdown Toolkit
============

Handy tool(soon to be tool**s**) to make markdown editing a bit less tedious.

(Activates only when `Markdown` is in the title of your file's active grammar.)

Hopefully a handy companion to `markdown-preview-plus` package, which is more of an output thing.

# Table of Contents
<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Table of Contents Generator](#table-of-contents-generator)
	- [Usage](#usage)
	- [Options / Features](#options-features)
		- [Selectable header depth](#selectable-header-depth)
		- [Style Options](#style-options)
		- [Update options](#update-options)
	- [Contributions / Thanks](#contributions-thanks)
- [Installation](#installation)
- [License](#license)

<!-- /TOC -->

## Table of Contents Generator

Automatically create a table of contents from your headings

### Usage

From the `Packages->Markdown Toolkit` dropdown menu, select `Insert Table of Contents`.  It will automatically insert a TOC tag and populate it based on your document headings.

If you would like to add it manually, add the following to your markdown file:
```
<!-- TOC -->
```
And the generator will take care of the rest.

### Options / Features

Default options will automatically be added to your TOC tag immediately (also by default, selectable if you'd prefer otherwise), specified below.

To return an option to default, delete it from the TOC tag. It will reappear with a default value shortly. (based on your save options)
  * **Note:** Invalid values will also be rewritten as defaults.

#### Selectable header depth
[Markdown's design](https://www.markdownguide.org/basic-syntax/) calls for 6 levels of headers. By default, we look for and include all of them in the Table of Contents.

Changes take effect based on `updateType`

* `depthFrom`: [1-6] / default: `1`
	* Include header levels at or below this level.  (1 means H1 and below, 2 means H2 and below, etc)
* `depthTo`: [1-6] / default: `6`
  * Include header levels at or above this level.

**Note:** if either value results in an invalid configuration, both will be reset to defaults.

#### Style Options
* `withLinks`: [true, false] / default: `true`
  * Generate links from the ToC to the sections themselves
* `listType`: ["ordered","unordered"] / default: `"unordered"`
  * Do you want a bulleted (`unordered`) or numbered (`ordered`) list?

Changes take effect based on `updateType`

#### Update options
Choose how often to auto-update the Table of Contents section.  Run `Markdown Toolkit: Update Table of Contents` from the command palette manually to update.
* `updateType`: ["live","onSave","none"] / default: `"live"`
	* Refresh the table of contents on this basis.  Takes effect immediately.
	  * `live`: Update the Table of Contents as you edit. (It waits until you stop typing before updating.)
		* `onSave`: Update only when saving the document. (This includes any autosaving you may have set up.)
		* `none`: Stop auto-updating the Table of Contents.
	* Changes take effect immediately.

### Contributions / Thanks

Thank you [Darius Morawiec](https://github.com/nok) for the original `markdown-toc`.  I would have given up without your work.

And to the people who contributed to it as well:

- [Giacomo Bresciani](https://github.com/brescia123)
- [Kévin Lanceplaine](https://github.com/lanceplaine)
- [Ilya Zelenin](https://github.com/wyster)
- [spjoe](https://github.com/spjoe)
- [Tom Byrer](https://github.com/tomByrer)
- [betrue12](https://github.com/betrue12)


## Installation
You can't lol, it's not published yet.  I mean you can, you just have to do it yourself for the moment. TODO: make this professional or remove it
```bash
apm install markdown-toolkit
```



## License

The package is Open Source Software released under the [MIT](LICENSE.md) license.
