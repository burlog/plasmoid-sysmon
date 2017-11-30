/*
 * Copyright (C) 2017 Michal Bukovský <burlog@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("Configuration")
         icon: "systemsettings"
         source: "Config.qml"
    }
    ConfigCategory {
         name: i18n("System Monitor Data Source")
         icon: "utilities-system-monitor"
         source: "SystemMonitorDataSourceConfig.qml"
    }
    ConfigCategory {
         name: i18n("Executabale Data Source")
         icon: "application-x-executable"
         source: "ExecutableDataSourceConfig.qml"
    }
    ConfigCategory {
         name: i18n("Examples")
         icon: "user-desktop"
         source: "ExampleConfig.qml"
    }
}

