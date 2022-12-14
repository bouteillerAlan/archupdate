import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0

import "../_toolbox" as Tb
import "../service" as Sv

Item {
    id: archupdate
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: Compact {}
    // load one instance of each needed service
    Sv.Updater{ id: updater }
    Tb.Cmd { id: cmd }
}
