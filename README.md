# System Monitor Engine Visualisation Plasmoid

The sysmon plasmoid is based on KDE standard system load plasmoids which are
constrained to some chosen metrics like CPU load. In contrast, the sysmon can
show any metric provided by the System Monitor data source engine.

![Example of configuration](https://raw.githubusercontent.com/burlog/plasmoid-sysmon/master/img/sysmon.config.png)

It can look like that:

![How it looks](https://raw.githubusercontent.com/burlog/plasmoid-sysmon/master/img/sysmon.png)

It is written completely in QML declarative language.

## Dependencies

 * Plasma 5 (Plasma Shell)
 * Plasma Framework Development Package (for installing)

# Installation

Installation is pretty simple and straight forward:

```shell
$ git clone https://github.com/burlog/plasmoid-sysmon.git plasmoid-sysmon
$ cd plasmoid-sysmon
$ plasmapkg2 -t plasmoid -i ./plasmoid
```

After installation you can find the plasmoid in widgets list and installed
files in `~/.local/share/plasma/plasmoids/com.github.burlog.plasmoid-sysmon/`.

# Devel

If you want to preview the plasmoid during dev just type this:

```shell
$ git clone https://github.com/burlog/plasmoid-sysmon.git plasmoid-sysmon
$ cd plasmoid-sysmon
$ plasmoidviewer --applet ./plasmoid
```

# License

The sysmon plasmoid is licensed under the GNU General Public License Version 2 or later.

You can modify or/and distribute it under the conditions of this license.

