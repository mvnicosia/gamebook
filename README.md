# gamebook

 Play gamebooks written in github-flavored markdown.

## Parsing

### Headings (1-3) are parsed into pages

 * Only use headings led with hashtags (#).
 * Any text under a heading (and before the next) is parsed into the text for that section (page).
 * H1 is parsed as the book title; any text under it is parsed onto the title page.

### Links between pages (Choices)

 * A section will be auto-linked to the subsequent section using the text `Continue...` if no choices are provided.
 * Choices may be provided using the text `_CHOICES:_` and an unordered-list:
 ```
### Example Section With Choices

Here is a section that has choices.

_CHOICES:_
* [Choose option 1](#option-1)
* [Choose option 2](#option-2)


### Option 1

You chose poorly.

_The End_

### Option 2

You chose wisely.

 ```

### Endings

Ending sections are signaled with `_The End_` without choices. The back button will still work. A landscape icon will display.
