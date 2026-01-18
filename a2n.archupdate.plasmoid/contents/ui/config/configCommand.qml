import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQuickControls

Kirigami.ScrollablePage {

  id: commandConfigPage

  property alias cfg_updateInterval: updateIntervalSpin.value
  property alias cfg_debugMode: debugModeBox.checked
  property alias cfg_retryMode: retryModeBox.checked
  property alias cfg_notCloseCommand: notCloseBox.checked

  property alias cfg_updateCommand: updateCommandInput.text
  property alias cfg_updateCommandOne: updateCommandOneInput.text
  property alias cfg_countArchCommand: countArchCommandInput.text
  property alias cfg_countAurCommand: countAurCommandInput.text

  property alias cfg_listArchCommand: listArchCommandInput.text
  property alias cfg_listAurCommand: listAurCommandInput.text

  property alias cfg_termCmd: termCmdInput.text
  property alias cfg_termNoCloseCmd: termNoCloseCmdInput.text
  property alias cfg_termNoCloseSuffix: termNoCloseSuffixInput.text

  function generateCmdExample() {
    const shell = "<font color=\"" + Kirigami.Theme.disabledTextColor + "\">" + cfg_termNoCloseSuffix + "</font>'<br/>"
    const cmdA = "<font color=\"" + Kirigami.Theme.disabledTextColor + "\">" + cfg_termCmd + "</font> '<font color=\"" + Kirigami.Theme.positiveTextColor + "\">" + cfg_updateCommand + "</font>'<br/>"
    const cmdB = "<font color=\"" + Kirigami.Theme.disabledTextColor + "\">" + cfg_termCmd + "</font> '<font color=\"" + Kirigami.Theme.positiveTextColor + "\">" + cfg_updateCommandOne + "</font> packageName'<br/>"
    const cmdC = "<font color=\"" + Kirigami.Theme.disabledTextColor + "\">" + cfg_termNoCloseCmd + "</font> '<font color=\"" + Kirigami.Theme.positiveTextColor + "\">" + cfg_updateCommand + "</font>" + shell
    const cmdD = "<font color=\"" + Kirigami.Theme.disabledTextColor + "\">" + cfg_termNoCloseCmd + "</font> '<font color=\"" + Kirigami.Theme.positiveTextColor + "\">" + cfg_updateCommandOne + "</font> packageName" + shell
    return "Give the following command: <br/>" + cmdA + cmdB + cmdC + cmdD
  }

  ColumnLayout {

    anchors {
      left: parent.left
      top: parent.top
      right: parent.right
    }

    Kirigami.InlineMessage {
      Layout.fillWidth: true
      text: "This option enable log for each cmd exec by the plugin. (regex: ARCHUPDATE)"
      visible: debugModeBox.checked
    }

    Kirigami.FormLayout {
      wideMode: false

      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "General"
      }
    }

    Kirigami.FormLayout {

      Controls.SpinBox {
        id: updateIntervalSpin
        Kirigami.FormData.label: "Update every: "
        from: 1
        to: 1440 // 1 day
        editable: true
        textFromValue: (value) => value + " minute(s)"
        valueFromText: (text) => parseInt(text)
      }

      Controls.CheckBox {
        id: notCloseBox
        Kirigami.FormData.label: "Do not close the terminal at the end of the upgrade action: "
        checked: false
      }

      Controls.CheckBox {
        id: debugModeBox
        Kirigami.FormData.label: "Debug: "
        checked: false
      }

      Controls.CheckBox {
        id: retryModeBox
        Kirigami.FormData.label: "Retry \"Search & count\" cmd if they are in error: "
        checked: false
      }

    }
 
   Kirigami.FormLayout {
      wideMode: false

      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Search & count"
      }
    }

    Kirigami.InlineMessage {
      Layout.fillWidth: true
      text: "Replace yay by paru or with the AUR helper of your choice.\n checkupdates is recommanded for the db sync.\nFor paru you may want to ignore ignored package with paru -Qua | grep -v ' \[ignored\]$' | wc -l for example"
      visible: true
    }

    Kirigami.FormLayout {
      wideMode: false

      Controls.TextField {
        id: countArchCommandInput
        Kirigami.FormData.label: "Count ARCH command: "
      }
 
      Controls.TextField {
        id: countAurCommandInput
        Kirigami.FormData.label: "Count AUR command: "
      }

      Controls.TextField {
        id: listArchCommandInput
        Kirigami.FormData.label: "List ARCH command: "
      }

      Controls.TextField {
        id: listAurCommandInput
        Kirigami.FormData.label: "List AUR command: "
      }
    }

      Kirigami.FormLayout {
        wideMode: false

        Kirigami.Separator {
          Kirigami.FormData.isSection: true
          Kirigami.FormData.label: "Update package"
        }
      }

      Kirigami.FormLayout {
        wideMode: false

        Kirigami.Heading {
          level: 3
          width: parent.width
          text: generateCmdExample()
        }

        Controls.TextField {
          id: updateCommandInput
          Kirigami.FormData.label: "Update all packages command: "
        }

        Controls.TextField {
          id: updateCommandOneInput
          Kirigami.FormData.label: "Update one package command: "
        }

        Controls.TextField {
          id: termCmdInput
          Kirigami.FormData.label: "Command for the update action: "
        }

        Controls.TextField {
          id: termNoCloseCmdInput
          Kirigami.FormData.label: "Command for the update action with do no close: "
        }

        Controls.TextField {
          id: termNoCloseSuffixInput
          Kirigami.FormData.label: "Command that run after the \"do not close\" command: "
        }
      }

  }

}
