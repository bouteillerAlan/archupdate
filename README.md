# Arch update counter - plasma widget

![screenshot of the plugin](git-assets/img/screenshot.png)

## Description

Counts the number of pacman update available.

Refresh each 30 minutes or on click.

## Installation

You need to have the [`pacman-contrib`](https://archlinux.org/packages/community/x86_64/pacman-contrib/) package installed.

Place the source (`a2n.archupdate.plasmoid` folder) in `~/.local/share/plasma/plasmoids/` or dl via [the KDE store](https://www.pling.com/p/1940819/)

## Configuration

| Name | Description | Result |
|--|--|--|
| Interval configuration | set the interval between each execution of the update check function | the `updater` is launch each X minutes |

## Code of conduct, license, authors, changelog, contributing

See the following file :
- [code of conduct](CODE_OF_CONDUCT.md)
- [license](LICENSE)
- [authors](AUTHORS)
- [contributing](CONTRIBUTING.md)
- [changelog](CHANGELOG)
- [security](SECURITY.md)

## Roadmap

- [x] ~~update the ui when `cmd` call `count`~~
- [x] ~~execute db update before the calcul~~
- [ ] setup a auto release w/ github action (ci/cd)
- [ ] add config :
  - [ ] icon choice
  - [ ] icon color
  - [ ] text color
  - [x] ~~interval choice~~

## Want to participate? Have a bug or a request feature?

Do not hesitate to open a pr or an issue. I reply when I can.

## Want to support my work?

- [Give me a tips](https://ko-fi.com/a2n00)
- [Give a star on github](https://github.com/bouteillerAlan/archupdate)
- [Add a rating and a comment on Pling](https://www.pling.com/p/1940819/)
- [Become a fan on Pling](https://www.pling.com/p/1940819/)
- Or just participate to the developement :D

### Thanks !
