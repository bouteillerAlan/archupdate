import QtQuick
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.kquickcontrolsaddons as KQuickAddons
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes

Button {
  id: configIcon

  property string defaultValue: "software-update-available.svg"
  property string value: ""

  function generateIconPath() {
    let path = value;
    if (value === defaultValue) {
      path = "../../assets";
    }
    if (value.split("/").lenght > 1) {
      const path = defaultValue.split("/");
      path.pop();
      path = path.toString();
    }
    if (path === value) {
      const location = plasmoid.location === PlasmaCore.Types.Vertical || plasmoid.location === PlasmaCore.Types.Horizontal;
      path = location ? "widgets/panel-background" : "widgets/background";

    }
    console.log("A2NARCHUPATE", defaultValue, value, path);
    return path;
  }

  implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
  implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2

  KIconThemes.IconDialog {
    id: iconDialog
    onIconNameChanged: {
      configIcon.value = iconName || configIcon.defaultValue;
    }
  }

  onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

  KSvg.FrameSvgItem {
    id: previewFrame
    anchors.centerIn: parent
    imagePath: generateIconPath()
    width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
    height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

    Kirigami.Icon {
      anchors.centerIn: parent
      width: Kirigami.Units.iconSizes.large
      height: width
      source: configIcon.value
    }
  }

  Menu {
    id: iconMenu

    // Appear below the button
    y: +parent.height

    MenuItem {
      text: i18ndc("plasma_applet_org.kde.plasma.kickoff", "@item:inmenu Open icon chooser dialog", "Choose...")
      icon.name: "document-open-folder"
      onClicked: iconDialog.open()
    }
    MenuItem {
      text: i18ndc("plasma_applet_org.kde.plasma.kickoff", "@item:inmenu Reset icon to default", "Clear Icon")
      icon.name: "edit-clear"
      onClicked: configIcon.value = configIcon.defaultValue
    }
  }
}

