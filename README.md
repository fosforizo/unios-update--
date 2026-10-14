# UniOS-Update

## Table of contents

- [Description](#description)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Tips & tricks and troubleshooting](#tips--tricks-and-troubleshooting)
- [Reproduce the pre-compiled tray binary from source](#reproduce-the-pre-compiled-tray-binary-from-source)
- [Contributing](#contributing)
- [License](#license)

## Description

An interactive update notifier & applier for UniOS that assists you with important pre / post update tasks. 
Includes a systray applet for an easy integration with any desktop / graphical environment.
You will see a lot of referals to Arch Linux because UniOS is a respin. This notifier is the one Arch Linux uses with stylistic changes to fit our operating system.

UniOS-Update is designed to follow usual system maintenance steps, as [described in the Arch Wiki](https://wiki.archlinux.org/title/System_maintenance).

Features:

- Automatic check and listing of available updates.
- Check for recent Arch Linux news (and offers to display them if there are).
- Check for orphan packages (and offers to remove them if there are).
- Check for old & uninstalled packages in cache (and offers to remove them if there are).
- Check for pacnew & pacsave files (and offers to process them if there are).
- Check for pending kernel update requiring a reboot (and offers to do so if there's one).
- Check for services requiring a post upgrade restart (and offers to do so if there are).
- Support for `sudo`, `sudo-rs`, `doas` & `run0`.
- Extensive CLI.

Optional support for:

- Flatpak packages (via `flatpak`).
- Desktop notifications (via `libnotify`).
- Check for ALHP build queue or outdated mirrors (via `alhp-utils`).

## Installation

### From Source

Install required runtime dependencies:

```bash
sudo pacman -S --needed bash systemd pacman pacman-contrib archlinux-contrib glibc libgcc curl fakeroot htmlq diffutils hicolor-icon-theme glib2 xdg-utils util-linux
```

Additional optional dependencies you might want or need:

- [flatpak](https://archlinux.org/packages/extra/x86_64/flatpak/): Flatpak Packages support
- [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/): Desktop notifications support on new available updates (see <https://wiki.archlinux.org/title/Desktop_notifications>)
- [alhp-utils](https://aur.archlinux.org/packages/alhp-utils): Check for ALHP build queue or outdated mirrors
- [vim](https://archlinux.org/packages/extra/x86_64/vim/): Default diff program for pacdiff
- [neovim](https://archlinux.org/packages/extra/x86_64/neovim/): Default diff program for pacdiff if `EDITOR=nvim`
- [sudo](https://archlinux.org/packages/core/x86_64/sudo/): Privilege elevation
- [sudo-rs](https://archlinux.org/packages/extra/x86_64/sudo-rs/): Privilege elevation
- [opendoas](https://archlinux.org/packages/extra/x86_64/opendoas/): Privilege elevation

Install required build and test dependencies:

```bash
sudo pacman -S --asdeps make scdoc bats cargo pkgconf
```

Download the archive of the [latest stable release](https://github.com/Antiz96/arch-update/releases/latest) and extract it (alternatively, you can clone this repository with `git`).

To build and install `unios-update`, go into the extracted / cloned directory and run the following commands:

```bash
make # You can optionally pass the `WITH_TRAY=false` argument to not build the systray applet
make test
sudo make install # You can optionally pass the `WITH_TRAY=false` argument to not install the systray applet
```

Once the installation is complete, you may optionally clean up the directory of files generated during installation by running the following command:

```bash
make clean
```

To uninstall `unios-update`, go into the extracted / cloned directory and run the following command:

```bash
sudo make uninstall
```

## Usage

For desktop machines, the usage consist of starting [the systray applet](#the-systray-applet) and enabling [the automated update checks](#the-automated-update-checks).  
For headless machines, `UniOS-Update` includes an extensive CLI.

### The systray applet

To start the systray applet and enable it automatically at boot, run the following command (preferred method for most environments, uses [XDG Autostart](https://wiki.archlinux.org/title/XDG_Autostart)):

```bash
unios-update --tray --enable
```

In case your graphical environment doesn't support XDG Autostart, add the following command your environment auto-start method instead:

*Note that the small startup delay in the form of the `sleep 3` command may not always be required but acts as a useful trick to avoid eventual [race condition](https://en.wikipedia.org/wiki/Race_condition) issues which may lead to the systray applet unexpectedly not starting at boot. I therefore recommend its usage as a safety measure (this small delay is already applied by default with the XDG Autostart / `unios-update --tray --enable` method).*

```bash
sleep 3 && unios-update --tray
```

The systray icon dynamically changes to indicate the current state of your system ('up to date' or 'updates available'). When clicked, it launches `unios-update` in a terminal window via the [unios-update.desktop](https://github.com/Antiz96/arch-update/blob/main/res/desktop/arch-update.desktop) file.  
The systray applet menu shows further information (like the list of pending updates, time of the last and next checks, ...) and allows to trigger specific actions (like running UniOS-Update, check for updates, ...). See [screenshots](#screenshots) for more details.

**Notes:**

- GNOME shell does not support systray icons natively, GNOME users need to install the ["AppIndicator and KStatusNotifierItem Support" extension](https://extensions.gnome.org/extension/615/appindicator-support/) for the systray applet to work.

### The automated update checks

To enable automated and periodic checks for available updates, run the following command:

```bash
unios-update --check --enable
```

By default, a check is performed **at boot and then once every 6 hours**. The check cycle can be customized, see [this chapter](#modify-the-check-cycle).

### Screenshots

Once started, the systray applet appears in the systray area of your panel.  
It is the third icon on the left in the screenshot below:

![icon](/res/screenshots/tray-icon.png)


On hover if there are new available updates, the systray icon shows a notification indicating the number of available updates. You can click on it and run UniOS-Update:

![notif](/res/screenshots/updates-available.png)

When the systray icon is left-clicked, `unios-update` is run in a terminal window

![run](/res/screenshots/update-window.png)

From there, just let `UniOS-Update` guide you through the various steps required for a complete and proper update of your system! :smile:

Certain options can be enabled, disabled or modified via the `unios-update.conf` configuration file. See the [unios-update.conf(5) man page](doc/man/unios-update.conf.5.scd) for more details.

## Documentation

### unios-update

See `unios-update --help` and the [unios-update(1) man page](doc/man/unios-update.1.scd).

### unios-update configuration file

See the [unios-update.conf(5) man page](doc/man/unios-update.conf.5.scd).

## Tips & tricks and troubleshooting

### Modify the check cycle

If you enabled [the automated update checks](#the-automated-update-checks), a check for available updates is automatically launched at boot and then once each 6 hours.

If you want to customize the check cycle, run `systemctl --user edit --full unios-update.timer` and modify the `OnUnitActiveSec` value to your liking.  
For instance, if you want `UninOS-Update` to check for new updates every 4 hours instead:

```text
[...]
[Timer]
OnStartupSec=15
OnUnitActiveSec=4h
[...]
```

Time units are `s` for seconds, `m` for minutes, `h` for hours, `d` for days...  
See <https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html#Parsing%20Time%20Spans> for more details.

In case you want `UniOS-Update` to check for new updates only once at boot, you can simply delete the `OnUnitActiveSec` line completely.

## Contributing

You can contribute [here](https://github.com/open-source-uom/unios-update). We recomend following the [contributing guidelines](https://github.com/Antiz96/arch-update/blob/main/CONTRIBUTING.md) of Arch Linux.

## License

UniOS-Update is licensed under the [GPL-3.0 license](https://github.com/Antiz96/arch-update/blob/main/LICENSE) (or any later version of that license).
