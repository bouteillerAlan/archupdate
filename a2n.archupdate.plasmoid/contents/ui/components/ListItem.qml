import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.ItemDelegate {
    id: listItem

    // index      = index of the element in the model
    // repo       = name of the repo
    // websiteUrl = URL to the package repository page
    // name       = package name
    // fv         = from version
    // tv         = to version

    width: parent.width // throw a warning but work anyway

    function updateOne() {
        updater.launchOneUpdate(name)
    }

    function openRepoPage() {
        if (websiteUrl) {
            Qt.openUrlExternally(websiteUrl)
        }
    }

    // generate & style the name of the package
    function generateName() {
        const nc = plasmoid.configuration.nameUseCustomColor ? plasmoid.configuration.nameColor : Kirigami.Theme.textColor
        const sc = plasmoid.configuration.sourceUseCustomColor ? plasmoid.configuration.sourceColor : Kirigami.Theme.disabledTextColor
        return '<font color="' + nc + '"> ' + name + ' </font><font color="' + sc + '"> from ' + (repo) + '</font>'
    }

    // generate & style the version of the package
    function generateVersion() {
        const fvc = plasmoid.configuration.fvUseCustomColor ? plasmoid.configuration.fvColor : Kirigami.Theme.negativeTextColor
        const sc = plasmoid.configuration.separatorUseCustomColor ? plasmoid.configuration.separatorColor : Kirigami.Theme.textColor
        const tvc = plasmoid.configuration.tvUseCustomColor ? plasmoid.configuration.tvColor : Kirigami.Theme.positiveTextColor
        return '<font color="' + fvc + '">' + fv + '</font><font color="' + sc + '"> ' + plasmoid.configuration.separatorText + ' </font><font color="' + tvc + '">' + tv + '</font>'
    }

    contentItem: RowLayout {
        ColumnLayout {
            spacing: 2

            Kirigami.Heading {
                id: itemHeading
                level: 3
                width: parent.width
                text: generateName()
            }

            Controls.Label {
                id: itemLabel
                width: parent.width
                wrapMode: Text.Wrap
                text: generateVersion()
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignRight
            PlasmaComponents.ToolButton {
                id: repoToolButton
                icon.name: "internet-services-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                text: i18n("See repository")
                onClicked: openRepoPage()
                visible: websiteUrl !== ''
                PlasmaComponents.ToolTip {
                    text: parent.text
                }
            }
            PlasmaComponents.ToolButton {
                id: actionToolButton
                icon.name: "system-run-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                text: i18n("Update " + name)
                onClicked: updateOne()
                PlasmaComponents.ToolTip {
                    text: parent.text
                }
            }
        }
    }

    // separator
    Rectangle {
        id: headerSeparator
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Kirigami.Theme.textColor
        opacity: 0.25
        visible: true
    }

}
