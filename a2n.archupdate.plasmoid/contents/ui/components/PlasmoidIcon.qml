import QtQuick
import QtCore
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.workspace.components as WorkspaceComponents
import org.kde.plasma.plasmoid
import "."

Item {
    id: root

    property bool iconUseCustomColor: plasmoid.configuration.iconUseCustomColor
    property string iconColor: plasmoid.configuration.iconColor

    anchors.centerIn: parent
    property var source

    Kirigami.Icon {
        id: svgItem
        opacity: 1
        width: parent.width
        height: parent.height
        property int sourceIndex: 0
        anchors.centerIn: parent
        smooth: true
        isMask: {
            let src = root.source || "";
            return !src.startsWith("/") && !src.startsWith("~/") && !src.includes("://");
        }
        color: iconUseCustomColor ? iconColor : Kirigami.Theme.colorSet
        source: {
            let src = root.source || "software-update-available.svg";
            if (src.includes("://")) return src;
            if (src.startsWith("/")) return "file://" + src;
            if (src.startsWith("~/")) {
                let home = StandardPaths.standardLocations(StandardPaths.HomeLocation)[0];
                return "file://" + home + src.slice(1);
            }
            return Qt.resolvedUrl("../../assets/" + src);
        }
    }
}
