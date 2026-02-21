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

  /**
   * Extracts package details from a list of Arch Linux repository entries.
  */
  function getPackageDetails(listRepo, packageName) {
    // find the block for the specified package
    const regex = new RegExp(`\nName\\s+:\\s${packageName}`)
    const targetBlock = listRepo.find(e => regex.exec(e))

    if (!targetBlock) {
      return null
    }

    // parse the block into an object
    const lines = targetBlock.trim().split('\n')
    const packageDetails = {}

    lines.forEach((line, index) => {
      if (index === 0) {
        packageDetails["repo"] = line
      } else {
        const match = line.match(/^(\w[^:]+)\s*:\s*(.*)$/)
        if (match) {
          const key = match[1].trim().toLowerCase()
          const value = match[2].trim()
          packageDetails[key] = value
        }
      }
    })

    return packageDetails
  }

  /**
   * inject the list into the component
   */
  function injectList(list: string, listArchRepo: string) {
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
      let pdetail = null

      try {
        // split the input into blocks for each package, this remove the "Repository" word!
        // we also remove the null and empty
        const listRepo = listArchRepo.split(/Repository\s+:\s/)
        if (listRepo && listRepo.length > 0) {
          const listRepoClean = listRepo.filter(e => e)
          const detail = getPackageDetails(listRepoClean, name)
          if (detail) {
            let websiteUrl = ''
            switch(detail.repo) {
              case "aur": // just in case
              websiteUrl = `https://aur.archlinux.org/packages/${name}`
              break;
              case "endeavouros":
              websiteUrl = `https://github.com/endeavouros-team/PKGBUILDS/tree/master/${name}`
              break;
              default:
              websiteUrl = `https://archlinux.org/packages/${detail.repo}/${detail.architecture}/${name}/`
              break;
            }
            detail.websiteUrl = websiteUrl
            pdetail = detail
          }
        }
      } catch(err) {
        console.log("A2N.ARCHUPDATE: err:", err)
      }

      if (name.trim() !== "") {
        packageListModel.append({
          name: name,
          fv: fv,
          tv: tv,
          repo: pdetail && pdetail.repo ? pdetail.repo : '[not found]',
          websiteUrl: pdetail && pdetail.websiteUrl ? pdetail.websiteUrl : ''
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

    function onPackagesList(listAur, listArch, listArchRepo) {
      packageListModel.clear()
      full.packageList = listArch + listAur
      injectList(listAur, listArchRepo)
      injectList(listArch, listArchRepo)
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
