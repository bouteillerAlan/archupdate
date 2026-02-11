import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

import "components" as Components

PlasmaExtras.Representation {
    id: full

    property string totalAur: "0"
    property string totalArch: "0"
    property string packageList: ""
    property bool onRefresh: false
    property bool onError: false
    property string errorMessage: ""

    focus: true
    anchors.fill: parent

    Layout.minimumHeight: 200
    Layout.minimumWidth: 200
    Layout.maximumWidth: 400

    function updateAll() {
        if (!onRefresh) updater.launchUpdate()
    }

    function refresh() {
        if (!onRefresh) updater.countAll()
    }

    function injectList(list: string, isArch: bool, listArchRepo: string) {
        const lines = list.split("\n")
        lines.sort((a, b) => {
          const aDetails = a.split(/\s+/)
          const bDetails = b.split(/\s+/)
          return aDetails[0].localeCompare(bDetails[0])
        })
        lines.forEach(line => {
            const packageDetails = line.split(/\s+/)
            const name = packageDetails[0]
            const fv = packageDetails[1]
            const tv = packageDetails[3]

            let repoName = null
            let websiteUrl = null
            if (listArchRepo !== '') {
              const urls = listArchRepo.split('\n')
              const matchingUrl = urls.find(url => url.includes(name))
              if (matchingUrl) {
                const archReg = new RegExp(`/archlinux/(core|core-testing|extra|extra-testing|gnome-unstable|kde-unstable|multilib|multilib-testing)/`, 'i')
                const eosReg = new RegExp(`/endeavouros/repo/(endeavouros)/`)
                const archMatch = archReg.exec(matchingUrl)
                const eosMatch = eosReg.exec(matchingUrl)
                const match = archMatch || eosMatch
                repoName = match ? (archMatch ? archMatch[1].toLowerCase() : eosMatch[1]) : 'unknown'

                if (archMatch && archMatch[1]) {
                  websiteUrl = `https://archlinux.org/packages/${repoName}/x86_64/${name}/`
                } else if (eosMatch && eosMatch[1]) {
                  websiteUrl = `https://github.com/endeavouros-team/PKGBUILDS/tree/master/${name}`
                }
              }
            }

            if (!isArch) {
              websiteUrl = `https://aur.archlinux.org/packages/${name}`
            }

            if (name.trim() !== "") {
                packageListModel.append({
                    name: name,
                    fv: fv,
                    tv: tv,
                    repo: repoName ?? 'aur',
                    websiteUrl: websiteUrl ?? ''
                });
            }

        });
    }

    // list of the packages
    ListModel { id: packageListModel }

    // map the cmd signal
    Connections {
        target: cmd

        function onConnected(source) {
            onError = false
        }

        function onIsUpdating(status) {
            onRefresh = status
        }

        function onTotalAur(total) {
            full.totalAur = total
        }

        function onTotalArch(total) {
            full.totalArch = total
        }

        function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
            if (stderr !== '') {
                onError = true
                errorMessage = stderr
            }
        }

        /*
         * listAur & listArch = zoxide 0.9.8-2 -> 0.9.9-1
         * listArchRepo = https://mirror.theo546.fr/archlinux/extra/os/x86_64/zoxide-0.9.9-1-x86_64.pkg.tar.zst
         **/
        function onPackagesList(listAur, listArch, listArchRepo) {
            packageListModel.clear()
            full.packageList = listArch + listAur
            injectList(listAur, false, '')
            injectList(listArch, true, listArchRepo)
        }
    }

    // topbar
    RowLayout {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        width: parent.width

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 0

            Controls.Label {
                height: Kirigami.Units.iconSizes.medium
                text: 'Arch ' + full.totalArch + ' - Aur ' + full.totalAur
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 0

            PlasmaComponents.BusyIndicator {
                id: busyIndicatorUpdateIcon
                visible: onRefresh && packageList !== ""
            }

            PlasmaComponents.ToolButton {
                id: updateIcon
                height: Kirigami.Units.iconSizes.medium
                icon.name: "install-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                text: i18n("Install all updates")
                onClicked: updateAll()
                visible: !onRefresh && packageList !== ""
                PlasmaComponents.ToolTip {
                    text: parent.text
                }
            }

            PlasmaComponents.BusyIndicator {
                id: busyIndicatorCheckUpdatesIcon
                visible: onRefresh
            }

            PlasmaComponents.ToolButton {
                id: checkUpdatesIcon
                height: Kirigami.Units.iconSizes.medium
                icon.name: "view-refresh-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                text: i18n("Refresh list")
                visible: !onRefresh
                onClicked: refresh()
                PlasmaComponents.ToolTip {
                    text: parent.text
                }
            }
        }
    }

    // separator
    Rectangle {
        id: headerSeparator
        anchors.top: header.bottom
        width: parent.width
        height: 1
        color: Kirigami.Theme.textColor
        opacity: 0.25
        visible: true
    }

    // page view for the list
    Kirigami.ScrollablePage {
        id: scrollView
        visible: !onRefresh && !onError
        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }
        anchors.top: headerSeparator.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        ListView {
            id: packageView
            anchors.rightMargin: Kirigami.Units.gridUnit
            model: packageListModel
            delegate: Components.ListItem {} // automatically inject the data from the model
        }
    }

    // if not update is needed
    PlasmaExtras.PlaceholderMessage {
        id: upToDateLabel
        text: i18n("You're up-to-date !")
        anchors.centerIn: parent
        visible: !onRefresh && packageList === "" && !onError
    }

    // if an error happend
    Controls.Label {
        id: errorLabel
        width: parent.width
        text: i18n("Hu ho something is wrong\n" + errorMessage)
        anchors.centerIn: parent
        visible: onError
        wrapMode: Text.Wrap
    }

    // loading indicator
    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: onRefresh  && !onError
    }

    Component.onCompleted: {
        refresh()
    }
}
