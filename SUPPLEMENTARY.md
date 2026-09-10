# Mdnotes Supplementary Documentation
This document exists in case someone would like some more insight into the rationale behind certain design decisions for mdnotes (and to also keep the README concise). It currently contains information on directory structure, using LSPs, editing tables, how mdnotes aims to format your notes, and how the tests are run.

## Rationale
In this document I explain certain design decisions for `mdnotes`.

### Using Current File's Directory
In most note-taking apps, the notes directory is designated within its options or configuration. I chose to use the current file's directory in `mdnotes` for the following reasons,

- No configuration needed so you can create wikis anywhere on any machine
- Easily create small local wikis
- WikiLinks or inline links are directly linked to the file's location, which works like a filesystem
- Functionality like global rename, backlinks, etc. are scoped to the current file's directory

Essentially the plugin treats a directory as a namespace, instead of using a vault model.

### Using LSPs
The main reason I started this project was dissatisfaction with Markdown LSPs at the time, and I really wanted to use Neovim as my notes editor. Therefore, `mdnotes` is designed to work with Markdown LSPs by trying to fill the gaps and to also complement their current functionality. Unfortunately, I don't think the Markdown LSPs are there yet, so the default behaviour of the plugin is to have `prefer_lsp = false`. Please see the table below for how `mdnotes` tries to work with LSPs and Neovim itself.

|Feature                         |mdnotes                                      |LSP                                                        |Neovim                                                                 |
|--------------------------------|---------------------------------------------|-----------------------------------------------------------|-----------------------------------------------------------------------|
|Find references                 |Y (`:Mdn wikilink find_references`)          |Y (`:h vim.lsp.buf.references()` or `grr`)                 |N                                                                      |
|Rename links to current buffer  |Y (`:Mdn wikilink rename_references`)        |Y (`:h vim.lsp.buf.rename()` or `grn`, markdown-oxide only)|N                                                                      |
|Rename links to hovered WikiLink|Y (`:Mdn wikilink rename_references`)        |? (`:h vim.lsp.buf.rename()`, should work but it does not) |N                                                                      |
|Buffer History                  |Y (Sequential `:Mdn history go_back/forward`)|N                                                          |Y (Not Sequential `:h bp`/`:h bn`                                      |
|Path Completion                 |N                                            |Y (`:h lsp-completion`)                                    |Y (`:h i_CTRL-X_CTRL-F`)                                               |
|Opening WikiLinks               |Y (`:Mdn wikilink follow`)                   |Y (`:h vim.lsp.buf.definition()` or `CTRL-]`)              |Y (`:h gf`, needs .md extension in link, requires settings for Windows)|
 
 **Note:** Not all of the features of `mdnotes` are listed in this table, just the ones that are relevant to this section. Some LSPs provide more than just LSP features and their documentation should also be referenced along with this table.

### Editing Tables
`mdnotes` tries to complement Neovim functionality to make editing tables as easy as possible. See the table below for what functions Neovim does and what functions are done by `mdnotes`.

|Feature             |mdnotes                                  |Neovim                |
|--------------------|-----------------------------------------|----------------------|
|Insert empty rows   |Y (`:Mdn table row_insert_above/below`)  |N                     |
|Duplicate row       |N                                        |Y (`:h yy`)           |
|Delete row          |N                                        |Y (`:h dd`)           |
|Move row            |N                                        |Y (`:h dd` and `:h p`)|
|Insert empty columns|Y (`:Mdn table column_insert_left/right`)|N                     |
|Duplicate column    |Y (`:Mdn table column_duplicate`)        |Y (`:h visual-block`) |
|Delete column       |Y (`:Mdn table column_delete`)           |Y (`:h visual-block`) |
|Move column         |Y (`:Mdn table column_move_left/right`)  |N                     |


 **Note:** Not all of the features of `mdnotes` are listed in this table, just the ones that are relevant to this section.

## 📢 Supported Markdown Formatting
Here is the supported Markdown formatting for `mdnotes.nvim`. The plugin tries to adhere to the CommonMark and GitHub Flavoured Markdown spec as well as providing WikiLink support. The plan is to adhere to existing specs and **not** create another one specific for the plugin.

Markdown specifications that have influenced `mdnotes.nvim` Markdown syntax,
- [CommonMark](https://spec.commonmark.org/current/)
- [Github Flavored Markdown (GFM)](https://github.github.com/gfm/)
- [GitHub Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- [GitLab Flavored Markdown (GLFM)](https://docs.gitlab.com/user/markdown/)
- [Obsidian formatting](https://obsidian.md/help/syntax)
- [Markdown Flavors Comparison](https://github.com/ArchieCur/MARKDOWN_FLAVORS)

### Links
#### Inline Links
Opened with `:Mdn inline_link open`. Inserted with `:Mdn inline_link toggle` and `:Mdn assets insert`. If no extension is given to `file` below, it is treated as `.md`. Optional title is supported for all cases.
```
    [link](https://neovim.io)
    [link](path/to/file#fragment)
    [link](path/to/file#GFM Style Fragment Wth Spaces)
    [link](path/to/file#gfm-style-fragment-wth-spaces)
    [link](<path/to/file with spaces.md#fragment>)
    [link](#Original Fragment)
    [link](#original-fragment)
    [link](path/to/file.extension)
    ![image](path/to/image.extension)
    [link](destination "title")
```
#### Reference Links
Same rules for inline links apply to reference links. Full and collapsed reference links are supported.
```
    [link][]
    [more][links]

    [link]: path/to/file#fragment 
    [links]: https://neovim.io
```
#### WikiLinks
Opened with `:Mdn wikilink follow`. Can only be filenames, so `link` can also be `link.md`.
```
    [[link]]
    [[link#fragment]]
    [[link#fragment with spaces]]
    [[link#fragment-with-spaces]]
    [[link|alias]]
    [[link#fragment-with-spaces|alias]]
    [[link#fragment with spaces|alias]]
```
### Formatting
Toggled with `:Mdn formatting <format>_toggle`. Using `_` for the strong and emphasis formats needs to be specified in the `strong_format` and `emphasis_format` config options. The ***strong emphasis*** format can be done by first applying `emphasis` and then `strong`.
```
    **strong**
    __strong__
    *emphasis*
    _emphasis_
    ~~strikethrough~~
    `inline code`
    <autolink>
```
### Lists
All ordered and unordered CommonMark lists along with GFM task lists are supported.
```
    - Item
    + Item
    * Item
    1) Item
    2. Item
    - [x] Task lists with all ordered and unordered lists above
```
### Tables
The GFM table specification is supported.
```
|1r1c|1r2c|1r3c|
|----|----|----|
|2r1c|2r2c|2r3c|
|3r1c|3r2c|3r3c|
```
### Footnotes
Footnote support is based on [Markdown Guide's Extended Syntax](https://www.markdownguide.org/extended-syntax/#footnotes) (currently without multi-line)
```
This is a footnote [^1].
And also [^this].

[^1]: Footnote contents
[^this]: More contents
```

## Tests
Using [mini.test](https://github.com/nvim-mini/mini.test) for testing. For this project, if you want to run the tests then you need to install mini.test as a plugin locally. This was done to minimise dependencies in the repo. If you're not using lazy then you need to specify the `mini.test` location, using the `mini_path` variable in `scripts/minimal_init.lua`. To run the tests execute the following command in the project root,
```bash
nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua MiniTest.run()"
```
or for individual test files,
```bash
nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua MiniTest.run_file('tests/test_*.lua')"
```

