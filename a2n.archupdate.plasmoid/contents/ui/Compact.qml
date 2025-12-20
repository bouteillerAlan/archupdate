import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.workspace.components as WorkspaceComponents
import "components" as Components

Item {
  id: row

  property string iconUpdate: plasmoid.configuration.icon
  property string iconRefresh: plasmoid.configuration.secondaryIcon

  property string totalArch: "0"
  property string totalAur: "0"

  property bool separateResult: plasmoid.configuration.separateResult
  property string separator: plasmoid.configuration.separator

  property bool mainDot: plasmoid.configuration.mainDot
  property bool mainDotUseCustomColor: plasmoid.configuration.mainDotUseCustomColor
  property string mainDotColor: plasmoid.configuration.mainDotColor
  property int mainDotPosition: parseInt(plasmoid.configuration.mainDotPosition, 10)

  property bool secondDot: plasmoid.configuration.secondDot
  property bool secondDotUseCustomColor: plasmoid.configuration.secondDotUseCustomColor
  property string secondDotColor: plasmoid.configuration.secondDotColor
  property int secondDotPosition: parseInt(plasmoid.configuration.secondDotPosition, 10)

  property bool onUpdate: false
  property bool onRefresh: false

  property bool isPanelVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
  readonly property bool inTray: parent.objectName === "org.kde.desktop-CompactApplet"

  property real itemSize: Math.min(row.height, row.width)

  property bool invertMouseAction: plasmoid.configuration.invertMouseAction
  property bool mainIsRefresh: plasmoid.configuration.mainIsRefresh

  // not use
  function generateMainIconPath() {
    if (!iconUpdate) return "software-update-available.svg";
    if (iconUpdate.split("/").lenght > 1) return iconUpdate;
    // https://invent.kde.org/plasma/plasma-desktop/-/tree/master/applets/kickoff
    const location = plasmoid.location === PlasmaCore.Types.Vertical || plasmoid.location === PlasmaCore.Types.Horizontal;
    return location ? "widgets/panel-background" + iconUpdate : "widgets/background" + iconUpdate;
  }

  // updates the icon according to the refresh status
  function updateUi(refresh: bool) {
    onRefresh = refresh
    if (refresh) {
      updateIcon.source = iconRefresh
    } else {
      updateIcon.source = iconUpdate
    }
  }

  // event handler for the left click on MouseArea
  function onLClick() {
    if (!onRefresh || !onUpdate) updater.countAll()
  }

  // event handler for the middle click on MouseArea
  function onMClick() {
    if (!onRefresh || !onUpdate) {
      onUpdate = true
      updater.launchUpdate()
    }
  }

  // return true if the widget area is vertical
  function isBarVertical() {
    return row.width < row.height;
  }

  // generate the text for the count result
  function generateResult() {
    if (onRefresh) return " ↻ "
    if (separateResult) return ' ' + totalArch + separator + totalAur + ' '
    return ` ${parseInt(totalArch, 10) + parseInt(totalAur, 10)} `
  }

  // return true if update is needed (total > 0)
  function isUpdateNeeded() {
    return (parseInt(totalArch, 10) + parseInt(totalAur, 10)) > 0
  }

  // return true if update is needed (total > 0)
  function isArchUpdateNeeded() {
    return (parseInt(totalArch, 10) > 0)
  }

  // return true if update is needed (total > 0)
  function isAurUpdateNeeded() {
    return (parseInt(totalAur, 10) > 0)
  }

  // map the cmd signal
  Connections {
    target: cmd

    function onIsUpdating(status) {
      updateUi(status)
    }

    function onTotalAur(total) {
      row.totalAur = total
    }

    function onTotalArch(total) {
      row.totalArch = total
    }
  }

  Item {
    id: container
    height: row.itemSize
    width: height

    anchors.centerIn: parent

    Components.PlasmoidIcon {
      id: updateIcon
      height: container.height
      width: height
      source: iconUpdate
    }

    // MAIN BR
    Rectangle {
      visible: (secondDot ? mainDot && isArchUpdateNeeded() : mainDot && isUpdateNeeded()) && mainDotPosition === 2
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        right: container.right
        bottom: container.bottom
      }
    }

    // MAIN BL
    Rectangle {
      visible: (secondDot ? mainDot && isArchUpdateNeeded() : mainDot && isUpdateNeeded()) && mainDotPosition === 3
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        left: container.left
        bottom: container.bottom
      }
    }

    // MAIN TR
    Rectangle {
      visible: (secondDot ? mainDot && isArchUpdateNeeded() : mainDot && isUpdateNeeded()) && mainDotPosition === 0
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        right: container.right
        top: container.top
      }
    }

    // MAIN TL
    Rectangle {
      visible: (secondDot ? mainDot && isArchUpdateNeeded() : mainDot && isUpdateNeeded()) && mainDotPosition === 1
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        left: container.left
        top: container.top
      }
    }

    // SECOND BR
    Rectangle {
      visible: (secondDot && mainDot && isAurUpdateNeeded()) && secondDotPosition === 2
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: secondDotUseCustomColor ? secondDotColor : PlasmaCore.Theme.textColor
      anchors {
        right: container.right
        bottom: container.bottom
      }
    }

    // SECOND BL
    Rectangle {
      visible: (secondDot && mainDot && isAurUpdateNeeded()) && secondDotPosition === 3
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: secondDotUseCustomColor ? secondDotColor : PlasmaCore.Theme.textColor
      anchors {
        left: container.left
        bottom: container.bottom
      }
    }

    // SECOND TR
    Rectangle {
      visible: (secondDot && mainDot && isAurUpdateNeeded()) && secondDotPosition === 0
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: secondDotUseCustomColor ? secondDotColor : PlasmaCore.Theme.textColor
      anchors {
        right: container.right
        top: container.top
      }
    }

    // SECOND TL
    Rectangle {
      visible: (secondDot && mainDot && isAurUpdateNeeded()) && secondDotPosition === 1
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: secondDotUseCustomColor ? secondDotColor : PlasmaCore.Theme.textColor
      anchors {
        left: container.left
        top: container.top
     }
    }

    WorkspaceComponents.BadgeOverlay { // for the horizontal bar
      anchors {
        bottom: container.bottom
        right: container.right
      }
      text: generateResult()
      visible: !isPanelVertical && !mainDot
      icon: updateIcon
    }

    WorkspaceComponents.BadgeOverlay { // for the vertical bar
      anchors {
        verticalCenter: container.bottom
        right: container.right
      }
      text: generateResult()
      visible: isPanelVertical && !mainDot
      icon: updateIcon
    }

    MouseArea {
      anchors.fill: container // cover all the zone
      cursorShape: Qt.PointingHandCursor // give user feedback
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton
      onClicked: (mouse) => {
        if (invertMouseAction) {
          if (mouse.button == Qt.MiddleButton) {
            mainIsRefresh ? onLClick() : main.expanded = !main.expanded
          }
          if (mouse.button == Qt.LeftButton) onMClick()
        } else {
          if (mouse.button == Qt.LeftButton) {
            mainIsRefresh ? onLClick() : main.expanded = !main.expanded
          }
          if (mouse.button == Qt.MiddleButton) onMClick()
        }
      }
    }
  }
}
