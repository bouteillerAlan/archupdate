import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore

import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

import "../_toolbox" as Tb
import "../service" as Sv

PlasmoidItem {
    id: main

    property int intervalConfig: plasmoid.configuration.updateInterval
    property bool isOnDebug: plasmoid.configuration.debugMode
    property bool isOnUpdate: false
    property string tArch: "0"
    property string tAur: "0"
    property string listAur: ""
    property string listArch: ""
    property string listArchRepo: ""

    // load one instance of each needed service
    Sv.Updater{ id: updater }
    Sv.Checker{ id: checker }
    Sv.Debug{ id: debug }

    // the brain of the widget
    Plasma5Support.DataSource {
        id: cmd
        engine: "executable"
        connectedSources: []

        onNewData: function (sourceName, data) {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }

        onSourceConnected: function (source) {
            if (isOnDebug) debug.log('ARCHUPDATE - '+plasmoid.id+' - cmd connected: ' + source, false)
            isUpdating(true)
            connected(source)
        }

        onExited: function (cmd, exitCode, exitStatus, stdout, stderr) {
            if (isOnDebug) debug.log('ARCHUPDATE - '+plasmoid.id+' - cmd exited: ' + JSON.stringify({cmd, exitCode, exitStatus, stdout, stderr}), stderr !== "")
            if (stderr !== '') cmd.exec("kdialog --passivepopup 'Archupdate counter throw " + stderr + " error on cmd: " + cmd + "'")

            // handle the result for the count
            const cmdIsAur = cmd === plasmoid.configuration.countAurCommand
            const cmdIsArch = cmd === plasmoid.configuration.countArchCommand
            if (cmdIsArch) {
                let total = stdout.replace(/\n/g, '')
                totalArch(total)
                main.tArch = total
                updater.listArch()
            }
            if (cmdIsAur) {
                let total = stdout.replace(/\n/g, '')
                totalAur(total)
                main.tAur = total
                updater.listAur()
            }

            // handle the result for the list
            const cmdIsListAur = cmd === plasmoid.configuration.listAurCommand
            const cmdIsListArch = cmd === plasmoid.configuration.listArchCommand
            const cmdIsListArchRepo = cmd === plasmoid.configuration.listRepoArchCommand
            if (cmdIsListAur) listAur = stdout
            if (cmdIsListArch) listArch = stdout
            if (cmdIsListArchRepo) listArchRepo = stdout
            if (cmdIsListAur || cmdIsListArch) {
                packagesList(listAur, listArch, listArchRepo)
            }

            // handle the result for the checker
            if (cmd === "konsole -v") checker.validateKonsole(stderr)
            if (cmd === "checkupdates --version") checker.validateCheckupdates(stderr)

            const isUpdateCmd = cmd.startsWith(plasmoid.configuration.termCmd) || cmd.startsWith(plasmoid.configuration.termNoCloseCmd)
            const isOnError = stderr !== ""

            // retry the cmd if error execpt for the upgrade (that crash the plasmoid)
            if (isOnError && !isUpdateCmd && plasmoid.configuration.retryMode) {
                if (isOnDebug) debug.log('ARCHUPDATE - '+plasmoid.id+' - cmd retry after error : ' + cmd, true)
                cmd.exec(cmd)
            }

            // refresh after an update action
            if (isUpdateCmd) {
                if (isOnDebug) debug.log('ARCHUPDATE - an update end, refreshing : ' + cmd, false)
                updater.countAll()
            }

            isUpdating(false)
        }

        // execute the given cmd
        function exec(cmd: string) {
            if (!cmd) return
            connectSource(cmd)
        }

        signal isUpdating(bool status)
        signal packagesList(string listAur, string listArch, string listArchRepo)
        signal totalAur(string total)
        signal totalArch(string total)
        signal connected(string source)
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    // execute function count each updateInterval minutes
    Timer {
        id: timer
        interval: intervalConfig * 60000 // minute to milisecond
        running: true
        repeat: true
        triggeredOnStart: true // trigger on start for a first check
        onTriggered: updater.countAll()
    }

    // handle the "show when relevant" property for the systray
    function hasUpdate() {
        return !(tArch === "0" && tAur === "0")
    }
    Plasmoid.status: hasUpdate() ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus

    // map the UI
    compactRepresentation: Compact {}
    fullRepresentation: Full {}

    // map the context menu
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Update")
            icon.name: "install-symbolic"
            onTriggered: {
                updater.launchUpdate()
            }
        },
        PlasmaCore.Action {
            text: i18n("Refresh")
            icon.name: "view-refresh-symbolic"
            onTriggered: {
                updater.countAll()
            }
        }
    ]

    // load the tooltip
    toolTipItem: Loader {
        id: tooltipLoader
        Layout.minimumWidth: item ? item.implicitWidth : 0
        Layout.maximumWidth: item ? item.implicitWidth : 0
        Layout.minimumHeight: item ? item.implicitHeight : 0
        Layout.maximumHeight: item ? item.implicitHeight : 0
        source: "Tooltip.qml"
    }

    Component.onCompleted: {
        plasmoid.configuration.debugLog = "" // clear log window
    }
}
