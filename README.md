# Arch update counter - plasma widget

<img alt="Static Badge" src="https://img.shields.io/badge/Still_maintened-Yes_%3A)-green">

![screenshot of the aplet with all the alt](git-assets/img/allalt.png)

1 - custom icon color  |  2 - custom dot color  |  3 - default dot  |  4 - label with separator  |  5 - label without separator | 6 - in the system tray | 7 - package list

## Description

Counts the number of *aur* and *arch* update available (so all the db - extra, core, aur, ...).

Refresh each 30 minutes, on click or on the interval you set.

You can launch an update console via the context menu or the middle click of your mouse !

Custom setting for ALL the command !

You can choose between a dot or a label if an update is available.

Possibility to change the visual of the dot, the visual of the label and the visual of the icon.

A popup list all the available update.

And a lot of settings is provided for customizing all that !

## Installation

You can install the widget from :

* the KDE menu `Get New Widgets...`
* from the AUR, e.g. `yay -S kdeplasma-arch-update-notifier-git`

### Manual installation

#### Plasma 6

- place the `a2n.archupdate.plasmoid` folder from the latest release in `~/.local/share/plasma/plasmoids/`
- download via [the KDE store](https://www.pling.com/p/2134470/) (install in `~/.local/share/plasma/plasmoids/`)
- [Dl the package via the AUR](https://aur.archlinux.org/packages/plasma6-applets-arch-update-notifier) (install in `/usr/share/plasma/plasmoids/`)

#### plasma 5

If you want to use this plugin with kde plasma 5 you should use:
 - ["The new era release" (v4.2)](https://github.com/bouteillerAlan/archupdate/releases/tag/v4.2.1)
 - [this version on the pling store](https://www.pling.com/p/1940819/)

**Please note that this version is not maintained since the v4.2.**

#### Dependencies and AUR helper

You need to have the following packages installed on your system **OR** to edit the settings with your prefered one:
 - [`pacman-contrib`](https://archlinux.org/packages/extra/x86_64/pacman-contrib/) is used for the list and count of the main repository.
 - [`yay`](https://github.com/Jguer/yay) is used for the list and count of the AUR repository.
 - [`konsole`](https://archlinux.org/packages/extra/x86_64/konsole/) is used to launch the cmd for the upgrade.
 - [`kdialog`](https://archlinux.org/packages/extra/x86_64/kdialog/) is used too, but it's not mandatory because it's used just for alerting if a cmd throw an error.

If you want to use `paru` you should filter the result to remove any ignored package:

```sh
paru -Qua | grep -v '\[ignored\]' | wc -l
paru -Qua | grep -v '\[ignored\]' 
```

### How to help with the AUR package?

Go here: [https://github.com/bouteillerAlan/plasma6-applets-arch-update-notifier](https://github.com/bouteillerAlan/plasma6-applets-arch-update-notifier).

## How to have this in my system tray?

Go to the 'System Tray Settings' menu and activate it :)

*in some case you may need to log out / log in to see it in the list*

![screenshot of how to add in the systray](git-assets/img/add-systray.png)

## Configuration

![screenshot of the settings of the plugin](git-assets/img/set1.png)

### Command & debug

| Name      | Description      |
| ------------- | ------------- |
| Update every | the delay between each count |
| Do not close the terminal... | If set to true the terminal launch when any update action is trigger is keept open when the update is done |
| Debug | If set to true some debug log appear on journalctl |
| Retry "Search & Count" cmd | If the count commands end with an error (stderr) we retry to launch the cmd, keep in mind that this feature is not really battle tested and there are no failsafe for a possible infinite loop of retry |
| count arch command | the cmd we use to count the update from the main repository (use in the icon label) |
| count aur command | the cmd we use to count the update from the AUR, and other, repository (use in the icon label) |
| list arch command | the cmd we use to list the package from the main repository (use in the popup) |
| list aur command | the cmd we use to list the package from the AUR, and other, repository (use in the popup) |
| update all command | the cmd we use to update all the packages from any repository (use when you clik on install all updates) |
| update one command | the cmd we use to update one specific package (use when you click on the icon next to a package) |
| command for the update action | what terminal should launch the update command |
| command for the update action with do not close | same has precedent but allow you to keep the terminal open after the update command, you need to set "do not close the terminal" to true to use it |
| command to run after the do not close command | an optional command to run after the update command that is only use in addition to the do not close command, the default one is use to exec the default shell of the user to allow him to actually use the terminal after the end of the update command |

### Display

| Name      | Description      |
| ------------- | ------------- |
| Main icon | What icon is used for the main icon |
| Refresh icon | What icon is used when the applet is in "refreshing" mode |
| Custom icon color | If you want to change the colors icon |
| Show a dot | Set to true to get a dot in place of the label |
| Custom main dot options | If you want to change the color and position of the main dot |
| Separate the dot | Set to true if you want a dot for the mai repository and a second one for the others repository |
| Custom second dot options | Same has Custom main dot options but for the second dot |
| Separate result | Use to separate the result in the label from the main repository and the others one and to set a string separator between both in the label (could be an empty string) |

### Popup

All the option is used to customized the popup list, you got a live example on the top of the page.

### Mouse action

| Name      | Description      |
| ------------- | ------------- |
| Mouse action | What mouse button you want to use for each action |
| Main action behavior | What you want to do when clicking on the applet in the taskbar |


### Regarding the customization of the commands

If you have any problems after modifying the default settings (especially the cmds):

*quoting the ThinkFan repo here*

> If this program steals your car, kills your horse, smokes your dope or pees on your carpet... too bad, you're on your own.

Is up to you to double check the command you want to exec. In no case I'm responsible of anything if your system break due to your command.

The program launch the update command with `konsole -e` or the cmd that you put in the setting. So you can test your command or script with `konsole -e "my_command"` or the cmd that you put in the settings `mycmd "my_command"`.

For the update command you have a demo of each cmd just between the title of the section and the setting input.

When you update all the packages the default command is: `konsole -e (--noclose) 'yay'` where `noclose` is optional.

When you update one package the default command is: `konsole -e (--noclose) 'yay -Sy' packageName` where `noclose` is optional and `packageName` is injected from the list.

## FAQ

### Why all these options for a similar command

I like to have the opportunity to really configure everything, and to do so simply.

### Why `yay` and `pacman-contrib`

`pacman-contrib` provide `checkupdates` for counting the update for the `core` and `extra` repository AND it sync all the db automatically without the need of sudo.

I'have setup `yay` because I use EOS, but, you can use `paru` in the exact same way, you just have to update the command in the settings window.

### Why not just `yay -Qu` (or `paru -Qu`)

Because this command dosen't sync the DB at the same time so the result is wrong.

For that we need to do something like the `-S` flag before and I prefer to use `checkupdates` for that (it's made for it so...).

### Why the `Do not close at the end` option when you can just update the terminal cmd

Because it's easier for people who don't want to update the default option to switch between not closing and closing the terminal at the end of the update.

### Why the update is made with yay and not pacman

Because `yay` cover all the db (core, extra, aur, ...) and `pacman` handle only core and extra.

### I want to update the PKGBUILD or the .SRCINFO for the AUR

You have to made a pr in this repository for that : [https://github.com/bouteillerAlan/kdeplasma-arch-update-notifier-git](https://github.com/bouteillerAlan/kdeplasma-arch-update-notifier-git)

## Code of conduct, license, authors, changelog, contributing

See the following file :
- [code of conduct](CODE_OF_CONDUCT.md)
- [license](LICENSE)
- [authors](AUTHORS)
- [contributing](CONTRIBUTING.md)
- [changelog](CHANGELOG)
- [security](SECURITY.md)

## Roadmap

- Nothing yet, I take feature request on the go :)

## Want to participate? Have a bug or a request feature?

Do not hesitate to open a pr or an issue. I reply when I can.

## Want to support my work?

- [Give me a tips](https://ko-fi.com/a2n00)
- [Give a star on github](https://github.com/bouteillerAlan/archupdate)
- [Add a rating and a comment on Pling](https://www.pling.com/p/2134470/)
- [Become a fan on Pling](https://www.pling.com/p/2134470/)
- Or just participate to the developement :D

### Thanks !
