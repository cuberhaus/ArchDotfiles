# Cuberhaus's dotfiles
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Cuberhaus's dotfiles](#cuberhauss-dotfiles)
    - [Installation](#installation)
    - [Shortcuts](#shortcuts)
    - [Recommendations](#recommendations)
    - [Supported OS](#supported-os)
    - [Window Managers](#window-managers)
    - [WIP](#wip)

<!-- markdown-toc end -->

Opinionated defaults, this repo is not meant to be used by everyone, just a personal configuration to take ideas out of. However if you are brave enough you can install it with the instructions below, you are advised to read the installation scripts before hand. 

## Installation

Clone repo and its submodules:

```bash
git clone --recurse-submodules https://github.com/cuberhaus/dotfiles ~/dotfiles/dotfiles
```

Use Stow to symlink files:

    cd ~
    mkdir dotfiles
    cd dotfiles
    git clone https://github.com/cuberhaus/dotfiles
    stow -vt ~ dotfiles/

Install scripts are located within .local/scripts/bootstrap/

> Tip: read script before executing

```bash
bash .local/scripts/arch
```

## Shortcuts

Shortcuts to applications are stored in /usr/share/applications/

## Recommendations

*   Read this repo's wiki
*   That's pretty much all

## Supported OS

*   ![Arch\_icon][arch_icon] Arch
*   ![Manjaro\_icon][manjaro_icon] Manjaro
*   ![Ubuntu\_icon][ubuntu_icon] Ubuntu
*   ![MacOS\_icon][macos_icon] MacOS

## Window Managers
* Xmonad (Main config)
* i3 (Second best)
* Cinnamon desktop
* Gnome

## WIP

*   ![Gentoo\_icon][gentoo_icon]Gentoo
*   Openbox

[warning_icon]: https://i.imgur.com/ORHMjm1.png?1

[rclone_icon]: https://i.imgur.com/2S75O8C.png?1

[ssh icon2]: https://i.imgur.com/RY2Xk5O.png?1

[ssh icon]: https://i.imgur.com/Jtz8Dma.png?1

[gnu icon]: https://i.imgur.com/dc4F2u2.png?1

[windows 10 icon]: https://i.imgur.com/b3co2Zl.png

[ova]: https://wikis.utexas.edu/display/MSBTech/Installing+OVA+files+using+VirtualBox#:~:text=An%20OVA%20file%20is%20an,have%20installed%20on%20your%20computer.

[brew page]: https://brew.sh/

[manjaro_icon]: https://i.imgur.com/rfuvfYo.png

[arch_icon]: https://upload.wikimedia.org/wikipedia/commons/a/a5/Archlinux-icon-crystal-64.svg

[ubuntu_icon]: https://i.imgur.com/EX9n2Ib.png?1

[macos_icon]: https://i.imgur.com/olG7ewE.png?1

[gentoo_icon]: https://i.imgur.com/cKReKS2.png

[only commit]: https://stackoverflow.com/questions/9683279/make-the-current-commit-the-only-initial-commit-in-a-git-repository
