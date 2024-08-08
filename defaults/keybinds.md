# Keybindings

## Copy mode

| Modifiers | Key      | Description                           |
|-----------|----------|---------------------------------------|
|           | Escape   | Cancel the mode                        |
| CTRL      | c        | Cancel the mode                        |
|           | Enter    | Move to start of next line             |
|           | $        | Move to end of line content            |
|           | 0        | Move to start of line                  |
|           | ^        | Move to start of line content          |
|           | End      | Move to end of line content            |
|           | Home     | Move to start of line                  |
| SHIFT     | g        | Move to scrollback top                 |
| SHIFT     | G        | Move to scrollback bottom              |
| SHIFT     | H        | Move to viewport top                   |
| SHIFT     | L        | Move to viewport bottom                |
| SHIFT     | M        | Move to viewport middle               |
|           | o        | Move to other end of visual selection  |
| SHIFT     | O        | Move to other end of visual selection horizontally |
|           | v        | Visual line mode                       |
| SHIFT     | V        | Visual line mode                       |
| CTRL      | v        | Visual block mode                      |
| ALT       | v        | Visual semantic zone mode              |
|           | s        | Move backward semantic zone            |
| SHIFT     | S        | Move forward semantic zone             |
|           | h        | Move left                              |
|           | j        | Move down                              |
|           | k        | Move up                                |
|           | l        | Move right                             |
|           | LeftArrow| Move left                              |
|           | RightArrow| Move right                            |
|           | UpArrow  | Move up                                |
|           | DownArrow| Move down                              |
|           | w        | Move forward word                      |
|           | e        | Move to end of forward word            |
|           | b        | Move backward word                     |
| CTRL      | LeftArrow| Move backward word                     |
| CTRL      | RightArrow| Move forward word                     |
| CTRL      | d        | Move down by page (half)               |
| CTRL      | u        | Move up by page (half)                 |
|           | PageUp   | Move up by page                        |
|           | PageDown | Move down by page                      |
| CTRL      | b        | Move up by page                        |
| CTRL      | f        | Move down by page                      |
|           | y        | Copy to clipboard and exit mode        |
| SHIFT     | /        | Enter search mode and edit pattern    |
|           | /        | Enter search mode and edit pattern    |
|           | n        | Next match                             |
| SHIFT     | P        | Next match                             |
|           | p        | Previous match                         |
| SHIFT     | N        | Previous match                         |
|           | ,        | Jump reverse                           |
|           | ;        | Jump again                             |
|           | f        | Jump forward                           |
| SHIFT     | F        | Jump backward                          |
|           | t        | Jump backward (prev char)              |
| SHIFT     | T        | Jump backward (prev char)              |

### Visual mode

| Modifiers             | Key  | Description                     |
|-----------------------|------|---------------------------------|
| Shift, CTRL, ALT      | v    | Change visual mode              |
|                       | o    | Move to the other end of selection |
| SHIFT                 | O    | Move to the other end of selection |
|                       | s    | Semantic jump                   |
| SHIFT                 | S    | Semantic jump                   |
|                       | y    | Copy and exit                   |
|                       | h    | Move left                       |
|                       | j    | Move down                       |
|                       | k    | Move up                         |
|                       | l    | Move right                      |

### Search mode
| Modifiers       | Key        | Action                         | Description                            |
|-----------------|------------|--------------------------------|----------------------------------------|
|                 | Enter      | Accept Pattern                 | Enter copy mode with accepted pattern  |
|                 | Escape     | Exit Search Mode               | Exit search mode and enter copy mode   |
| CTRL            | c          | Exit Search Mode               | Exit search mode and enter copy mode   |
| CTRL            | n          | Next Match                     | Go to the next search match            |
| CTRL            | p          | Previous Match                 | Go to the previous search match        |
| CTRL            | r          | Cycle Match Type               | Cycle through match types              |
| CTRL            | u          | Clear Pattern                  | Clear the current search pattern       |
|                 | PageUp     | Prior Match Page               | Go to the previous match on the page   |
|                 | PageDown   | Next Match Page                | Go to the next match on the page       |
|                 | UpArrow    | Prior Match                    | Go to the previous match               |
|                 | DownArrow  | Next Match                     | Go to the next match                   |

## UI mode

| Modifiers       | Key        | Action                          | Description                             |
|-----------------|------------|---------------------------------|-----------------------------------------|
|                 | Escape     | Exit Mode                       | Exit UI mode                            |
| CTRL            | c          | Exit Mode                       | Exit UI mode                            |
|                 | h          | Activate Pane Left              | Move to left pane                       |
|                 | j          | Activate Pane Down              | Move to down pane                       |
|                 | k          | Activate Pane Up                | Move to up pane                         |
|                 | l          | Activate Pane Right             | Move to right pane                      |
| CTRL            | h          | Adjust Pane Size Left           | Resize pane left                        |
| CTRL            | j          | Adjust Pane Size Down           | Resize pane down                        |
| CTRL            | k          | Adjust Pane Size Up             | Resize pane up                          |
| CTRL            | l          | Adjust Pane Size Right          | Resize pane right                       |
|                 | LeftArrow  | Adjust Pane Size Left           | Resize pane left                        |
|                 | RightArrow | Adjust Pane Size Right          | Resize pane right                       |
|                 | UpArrow    | Adjust Pane Size Up             | Resize pane up                          |
|                 | DownArrow  | Adjust Pane Size Down           | Resize pane down                        |
|                 | z          | Toggle Zoom                     | Zoom in/out                             |
|                 | -          | Split Pane Vertical             | Split pane vertically                   |
| SHIFT           | _          | Split Pane Horizontal           | Split pane horizontally                 |
|                 | q          | Close Pane                      | Close current pane                      |
|                 | r          | Rotate Panes Clockwise          | Rotate panes clockwise                  |
| SHIFT           | R          | Rotate Panes CounterClockwise   | Rotate panes counterclockwise           |
| SHIFT           | S          | Pane Select                     | Select pane                             |
|                 | s          | Swap Panes                      | Swap active pane                        |
|                 | t          | Spawn New Tab                   | Open new tab                            |
| SHIFT           | T          | Close Tab                       | Close current tab                       |
| SHIFT           | H          | Activate Previous Tab           | Switch to previous tab                  |
| SHIFT           | L          | Activate Next Tab               | Switch to next tab                      |
|                 | Tab        | Activate Next Tab               | Switch to next tab                      |
| SHIFT           | Tab        | Activate Previous Tab           | Switch to previous tab                  |
| SHIFT           | J          | Move Tab Left                   | Move tab left                           |
| SHIFT           | K          | Move Tab Right                  | Move tab right                          |
| ALT             | t          | Show Tab Navigator              | Show tab navigator                      |
|                 | n          | Rename Tab                      | Rename current tab                      |
|                 | w          | Switch to Next Workspace        | Switch to next workspace                |
| SHIFT           | W          | Switch to Previous Workspace    | Switch to previous workspace            |
| SHIFT           | N          | Spawn New Window                | Open new window                         |
| SHIFT           | P          | Move Pane to New Window         | Move current pane to a new window       |
|                 | p          | Move Pane to New Tab            | Move current pane to a new tab          |
| CTRL            | +          | Increase Font Size              | Increase font size                      |
| CTRL            | -          | Decrease Font Size              | Decrease font size                      |
|                 | f          | Toggle Fullscreen               | Toggle fullscreen mode                  |

## Scroll mode

| Modifiers | Key      | Description                       |
|-----------|----------|-----------------------------------|
|           | Escape   | Cancel the "Scroll" mode           |
| CTRL      | c        | Cancel the "Scroll" mode           |
|           | UpArrow  | Scroll up by 1 line                |
|           | DownArrow| Scroll down by 1 line              |
|           | k        | Scroll up by 1 line                |
|           | j        | Scroll down by 1 line              |
| SHIFT     | UpArrow  | Scroll up by 5 lines               |
| SHIFT     | DownArrow| Scroll down by 5 lines             |
| SHIFT     | K        | Scroll up by 5 lines               |
| SHIFT     | J        | Scroll down by 5 lines             |
|           | u        | Scroll up by half a page           |
|           | d        | Scroll down by half a page         |
| SHIFT     | U        | Scroll up by a page                |
| SHIFT     | D        | Scroll down by a page              |
|           | p        | Scroll to previous prompt          |
|           | n        | Scroll to next prompt              |
|           | {        | Scroll to previous prompt          |
|           | }        | Scroll to next prompt              |
|           | g        | Scroll to top                      |
| SHIFT     | G        | Scroll to bottom                   |
|           | z        | Toggle pane zoom state             |
|           | v        | Activate "copy_mode"               |
|           | /        | Activate "search_mode"             |

