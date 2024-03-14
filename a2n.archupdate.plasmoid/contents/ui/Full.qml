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

    property string listAur: ""
    property string listArch: ""
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

    // list of the packages
    ListModel { id: packageListModel }

    // map the main signal
    Connections {
        target: main
        function onUpdatingList() {
            onRefresh = true
        }
        function onStoppedUpdatingList() {}
    }

    // map the cmd signal with the widget
    Connections {
        target: cmd

        function onConnected(source) {
            onError = false
        }

        function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
            // handle the result for the list
            const cmdIsListAur = cmd === plasmoid.configuration.listAurCommand
            const cmdIsListArch = cmd === plasmoid.configuration.listArchCommand
            if (cmdIsListAur) listAur = stdout
            if (cmdIsListArch) listArch = stdout

            if (cmdIsListAur || cmdIsListArch) {
                packageListModel.clear()
                let listAll = listAur + listArch
                listAll.split("\n").forEach(line => {
                    const packageDetails = line.split(/\s+/);
                    const name = packageDetails[0];
                    const fv = packageDetails[1];
                    const tv = packageDetails[3];
                    if (name.trim() !== "") {
                        packageListModel.append({
                            name: name,
                            fv: fv,
                            tv: tv,
                            isArch: cmdIsListArch
                        });
                    }

                });
            }

            if (stderr !== '') {
                onError = true
                errorMessage = stderr
            }

            onRefresh = false
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
                text: 'Arch ' + main.totalArch + ' - Aur ' + main.totalAur
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 0

            PlasmaComponents.BusyIndicator {
                id: busyIndicatorUpdateIcon
                visible: onRefresh && main.hasUpdate()
            }

            PlasmaComponents.ToolButton {
                id: updateIcon
                height: Kirigami.Units.iconSizes.medium
                icon.name: "install-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                text: i18n("Install all update")
                onClicked: updateAll()
                visible: !onRefresh && main.hasUpdate()
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
        visible: !onRefresh && listAur === "" && listArch === ""  && !onError
    }

    // if an error happend
    Controls.Label {
        id: errorLabel
        width: parent.width
        text: i18n("Hu ho something is wrong : " + errorMessage)
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
}
