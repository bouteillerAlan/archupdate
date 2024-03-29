import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQuickControls
import org.kde.plasma.components as PlasmaComponents

Kirigami.ScrollablePage {

    id: mouseConfigPage

    property alias cfg_invertMouseAction: invertMouseAction.checked
    property alias cfg_mainIsRefresh: mainIsRefresh.checked

    ColumnLayout {

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Kirigami.FormLayout {
            wideMode: false

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "Mouse action"
            }
        }

        Kirigami.FormLayout {

            ColumnLayout {
                PlasmaComponents.RadioButton {
                    text: i18n("Left click to check, middle click to update")
                    checked: true
                    autoExclusive: true
                }
                PlasmaComponents.RadioButton {
                    id: invertMouseAction
                    text: i18n("Middle click to check, left click to update")
                    autoExclusive: true
                }
            }

        }

        Kirigami.FormLayout {
            wideMode: false

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "Main action behavior"
            }
        }

        Kirigami.InlineMessage {
            Layout.fillWidth: true
            text: "Doing both at the same time is prone to bug so it's not possible"
            visible: true
        }

        Kirigami.FormLayout {
            RowLayout {
                Kirigami.FormData.label: "Do a refresh in place of openning the popup: "
                visible: true
                Controls.CheckBox {
                    id: mainIsRefresh
                    checked: cfg_mainIsRefresh
                }

            }

        }

    }

}

