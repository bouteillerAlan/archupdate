import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.workspace.components 2.0 as WorkspaceComponents
import "components" as Components

Item {
  id: row

  property string iconUpdate: "software-update-available.svg"
  property string iconRefresh: "arch-unknown.svg"
  property string totalArch: "0"
  property string totalAur: "0"
  property bool debug: plasmoid.configuration.debugMode
  property bool separateResult: plasmoid.configuration.separateResult
  property string separator: plasmoid.configuration.separator
  property bool onUpdate: false
  property bool onRefresh: false
  property bool isPanelVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
  readonly property bool inTray: parent.objectName === "org.kde.desktop-CompactApplet"

  property real itemSize: Math.min(row.height, row.width)

  // updates the icon according to the refresh status
  function updateUi(refresh: boolean) {
    onRefresh = refresh
    if (refresh) {
      updateIcon.source=iconRefresh
    } else {
      updateIcon.source=iconUpdate
    }
  }

  // event handler for the left click on MouseArea
  function onLClick() {
    updater.countAll()
  }

  // event handler for the middle click on MouseArea
  function onMClick() {
    onUpdate = true
    updater.launchUpdate()
  }

  // return true if the widget area is vertical
  function isBarVertical() {
    return row.width < row.height;
  }

  // generate the text for the count result
  function generateResult() {
    // todo for test remove me after
    return '152+158'
    if (onRefresh) return "↻"
    if (separateResult) return totalArch + separator + totalAur
    return `${parseInt(totalArch, 10) + parseInt(totalAur, 10)}`
  }

  // map the cmd signal with the widget
  Connections {
    target: cmd

    function onConnected(source) {
      if (debug) console.log('ARCHUPDATE - cmd connected: ', source)
      updateUi(true)
    }

    function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
      if (debug) console.log('ARCHUPDATE - cmd exited: ', JSON.stringify({cmd, exitCode, exitStatus, stdout, stderr}))

      // update the count after the update
      if (onUpdate || stdout === '') { // eg. the stdout is empty if the user close the update term with the x button
        onUpdate = false
        onLClick()
      }

      // handle the result for the count
      const cmdIsAur = cmd === plasmoid.configuration.countAurCommand
      const cmdIsArch = cmd === plasmoid.configuration.countArchCommand
      if (cmdIsArch) totalArch =  stdout.replace(/\n/g, '')
      if (cmdIsAur) totalAur =  stdout.replace(/\n/g, '')

      // handle the result for the checker
      if (cmd === "konsole -v") checker.validateKonsole(stderr)
      if (cmd === "checkupdates --version") checker.validateCheckupdates(stderr)

      updateUi(false)
    }
  }

  Rectangle {
    id: container
    height: row.itemSize
    width: height
    color: "red"

    anchors.centerIn: parent

    Components.PlasmoidIcon {
      id: updateIcon
      height: container.height
      width: height
      source: iconUpdate
    }

    // WorkspaceComponents.BadgeOverlay { // for the horizontal bar
    //   anchors {
    //     bottom: container.bottom
    //     right: container.right
    //   }
    //   text: generateResult()
    //   visible: !isPanelVertical
    //   icon: updateIcon
    // }
    //
    // WorkspaceComponents.BadgeOverlay { // for the vertical bar
    //   anchors {
    //     verticalCenter: container.bottom
    //     right: container.right
    //   }
    //   text: generateResult()
    //   visible: isPanelVertical
    //   icon: updateIcon
    // }

    MouseArea {
      anchors.fill: container // cover all the zone
      cursorShape: Qt.PointingHandCursor // give user feedback
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton
      onClicked: (mouse) => {
        if (mouse.button == Qt.LeftButton) {
          onLClick()
        } else if (mouse.button == Qt.MiddleButton) {
          onMClick()
        }
      }
    }
  }
}
