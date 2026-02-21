import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

Item {
    id: root
    width: parent ? parent.width : 400
    implicitHeight: layout.implicitHeight + 24

    property alias cfg_idleSource: idleSourceField.text
    property alias cfg_idleFrameCount: idleFrameCountField.value
    property alias cfg_idleFrameRate: idleFrameRateField.value
    property alias cfg_pressSource: pressSourceField.text
    property alias cfg_pressFrameCount: pressFrameCountField.value
    property alias cfg_pressFrameRate: pressFrameRateField.value

    function saveConfig() {
        plasmoid.configuration.idleSource = idleSourceField.text
        plasmoid.configuration.idleFrameCount = idleFrameCountField.value
        plasmoid.configuration.idleFrameRate = idleFrameRateField.value
        plasmoid.configuration.pressSource = pressSourceField.text
        plasmoid.configuration.pressFrameCount = pressFrameCountField.value
        plasmoid.configuration.pressFrameRate = pressFrameRateField.value
        plasmoid.configuration.writeConfig()

        console.log("idleSource: ", idleSourceField.text)
        console.log("idleFrameCount: ", idleFrameCountField.value)
        console.log("idleFrameRate: ", idleFrameRateField.value)
        console.log("pressSource: ", pressSourceField.text)
        console.log("pressFrameCount: ", pressFrameCountField.value)
        console.log("pressFrameRate: ", pressFrameRateField.value)
    }

    ColumnLayout {
        id: layout
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
        spacing: 12

        Label { text: "<b>Idle Animation</b>" }

        RowLayout {
            Layout.fillWidth: true
            Label { text: "Sprite Sheet:" }
            TextField {
                id: idleSourceField
                Layout.fillWidth: true
            }
            Button {
                text: "..."
                onClicked: idleFileDialog.open()
            }
        }

        RowLayout {
            Label { text: "Frames:" }
            SpinBox { id: idleFrameCountField; from: 1; to: 999 }
            Label { text: "FPS:" }
            SpinBox { id: idleFrameRateField; from: 1; to: 999 }
        }

        Label { text: "<b>Press Animation</b>" }

        RowLayout {
            Layout.fillWidth: true
            Label { text: "Sprite Sheet:" }
            TextField {
                id: pressSourceField
                Layout.fillWidth: true
            }
            Button {
                text: "..."
                onClicked: pressFileDialog.open()
            }
        }

        RowLayout {
            Label { text: "Frames:" }
            SpinBox { id: pressFrameCountField; from: 1; to: 999 }
            Label { text: "FPS:" }
            SpinBox { id: pressFrameRateField; from: 1; to: 999 }
        }
    }

    FileDialog {
        id: idleFileDialog
        title: "Select Idle Sprite Sheet"
        nameFilters: ["Images (*.png *.jpg)"]
        onAccepted: idleSourceField.text = selectedFile.toString().replace("file://", "")
    }

    FileDialog {
        id: pressFileDialog
        title: "Select Press Sprite Sheet"
        nameFilters: ["Images (*.png *.jpg)"]
        onAccepted: pressSourceField.text = selectedFile.toString().replace("file://", "")
    }
}