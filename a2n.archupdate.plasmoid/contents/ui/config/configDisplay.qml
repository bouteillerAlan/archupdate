import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQuickControls

Kirigami.ScrollablePage {

  id: displayConfigPage

  property alias cfg_icon: configMainIconField.value
  property alias cfg_secondaryIcon: configSecondaryIconField.value

  property alias cfg_separateResult: separateResult.checked
  property alias cfg_separator: separator.text

  property alias cfg_mainDot: mainDot.checked
  property alias cfg_mainDotColor: mainDotColor.color
  property alias cfg_mainDotUseCustomColor: mainDotUseCustomColor.checked
  property alias cfg_mainDotPosition: mainDotPosition.currentIndex

  property alias cfg_secondDot: secondDot.checked
  property alias cfg_secondDotColor: secondDotColor.color
  property alias cfg_secondDotUseCustomColor: secondDotUseCustomColor.checked
  property alias cfg_secondDotPosition: secondDotPosition.currentIndex

  property alias cfg_iconColor: iconColor.color
  property alias cfg_iconUseCustomColor: iconUseCustomColor.checked

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
        Kirigami.FormData.label: "Icon"
      }
    }

    Kirigami.InlineMessage {
      Layout.fillWidth: true
      text: "You may need to refresh the widget to see any change if you choose another icon.\nI'm working on the problem. A quick way to do that is just to hit 'Refresh' in the widget menu."
      visible: true
    }

    Kirigami.FormLayout {
      anchors.left: parent.left
      anchors.right: parent.right

      ConfigIcon {
        id: configMainIconField
        Kirigami.FormData.label: "Main icon: "
        defaultValue: "software-update-available.svg"
      }
    }

    Kirigami.FormLayout {
      anchors.left: parent.left
      anchors.right: parent.right

      ConfigIcon {
        id: configSecondaryIconField
        Kirigami.FormData.label: "Refresh icon: "
        defaultValue: "arch-unknown.svg"
      }
    }

    Kirigami.FormLayout {
      RowLayout {
        Kirigami.FormData.label: "Custom icon color: "
        visible: true
        Controls.CheckBox {
          id: iconUseCustomColor
          checked: false
        }

        KQuickControls.ColorButton {
          id: iconColor
          enabled: iconUseCustomColor.checked
        }
      }

    }

    Kirigami.FormLayout {
      wideMode: false

      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Display"
      }
    }

    Kirigami.InlineMessage {
      Layout.fillWidth: true
      text: "The dot is shown only if update is needed.\nThis is the recommended option if you want to use the widget in your system tray or if you tend to have a lot of update that the label can't handle."
      visible: true
    }

    Kirigami.FormLayout {
      Controls.CheckBox {
        id: mainDot
        Kirigami.FormData.label: "Show a dot in place of the label: "
        checked: false
      }

      RowLayout {
        Kirigami.FormData.label: "Custom main dot options: "
        visible: mainDot.checked
        Controls.CheckBox {
          id: mainDotUseCustomColor
          checked: false
        }

        KQuickControls.ColorButton {
          id: mainDotColor
          enabled: mainDotUseCustomColor.checked
        }

        Controls.ComboBox {
          id: mainDotPosition
          enabled: mainDot.checked
          model: ["Top Right", "Top Left", "Bottom Right", "Bottom Left"]
          onActivated: cfg_mainDotPosition = index
        }
      }
    }

    Kirigami.FormLayout {
      visible: mainDot.checked
      Controls.CheckBox {
        id: secondDot
        Kirigami.FormData.label: "Separate the dot between the two command: "
        checked: false
      }
    }

    Kirigami.FormLayout {
      visible: secondDot.checked && mainDot.checked

      RowLayout {
        Kirigami.FormData.label: "Custom second dot options: "
        visible: secondDot.checked
        Controls.CheckBox {
          id: secondDotUseCustomColor
          checked: false
        }

        KQuickControls.ColorButton {
          id: secondDotColor
          enabled: secondDotUseCustomColor.checked
        }

        Controls.ComboBox {
          id: secondDotPosition
          enabled: secondDot.checked
          model: ["Top Right", "Top Left", "Bottom Right", "Bottom Left"]
          onActivated: cfg_secondDotPosition = currentIndex
        }
      }
    }

    Kirigami.FormLayout {
      wideMode: false

      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Label display"
      }
    }

    Kirigami.InlineMessage {
      Layout.fillWidth: true
      text: "Expected result: arch + seprator + aur"
      visible: true
    }

    Kirigami.FormLayout {
      Controls.CheckBox {
        id: separateResult
        Kirigami.FormData.label: "Separate result: "
        checked: false
      }

      Controls.TextField {
        id: separator
        Kirigami.FormData.label: "Separator: "
        visible: separateResult.checked
      }
    }



  }

}
