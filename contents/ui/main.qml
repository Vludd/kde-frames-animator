import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    width: 128
    height: 128

    Plasmoid.backgroundHints: "NoBackground"

    Component.onCompleted: {
        console.log("=== Config loaded ===")
        console.log("idleSource:", plasmoid.configuration.idleSource)
        console.log("idleFrameCount:", plasmoid.configuration.idleFrameCount)
        console.log("idleFrameRate:", plasmoid.configuration.idleFrameRate)
        console.log("pressSource:", plasmoid.configuration.pressSource)
        console.log("pressFrameCount:", plasmoid.configuration.pressFrameCount)
        console.log("pressFrameRate:", plasmoid.configuration.pressFrameRate)

        console.log("smoothFrames:", plasmoid.configuration.smoothFrames)
    }

    Connections {
        target: plasmoid.configuration
        function onIdleSourceChanged() { reloadSprite() }
        function onIdleFrameCountChanged() { reloadSprite() }
        function onIdleFrameRateChanged() { reloadSprite() }

        function onPressSourceChanged() { reloadSprite() }
        function onPressFrameCountChanged() { reloadSprite() }
        function onPressFrameRateChanged() { reloadSprite() }
    }

    function reloadSprite() {
        spriteLoader.sourceComponent = null
        spriteLoader.sourceComponent = spriteComponent
        console.log("=== SpriteSequence reloaded ===")
    }

    Loader {
        id: spriteLoader
        anchors.fill: parent
        active: true

        sourceComponent: spriteComponent
    }

    Component {
        id: spriteComponent

        Item {
            anchors.fill: parent
            property alias spriteObj: sprite

            SpriteSequence {
                id: sprite
                width: originalWidth
                height: originalHeight
                anchors.centerIn: parent

                smooth: plasmoid.configuration.smoothFrames

                property int originalWidth: 512
                property int originalHeight: 512
                
                goalSprite: "idle"

                scale: Math.min(
                    root.width / originalWidth,
                    root.height / originalHeight
                )
                transformOrigin: Item.Center

                Sprite {
                    name: "idle"
                    source: plasmoid.configuration.idleSource
                    frameCount: Math.max(plasmoid.configuration.idleFrameCount, 1)
                    frameWidth: originalWidth
                    frameHeight: originalHeight
                    frameRate: Math.max(plasmoid.configuration.idleFrameRate, 1)
                    to: {"idle": 1}
                }

                Sprite {
                    name: "press"
                    source: plasmoid.configuration.pressSource
                    frameCount: Math.max(plasmoid.configuration.pressFrameCount, 1)
                    frameWidth: originalWidth
                    frameHeight: originalHeight
                    frameRate: Math.max(plasmoid.configuration.pressFrameRate, 1)
                    to: {"idle": 1}
                }

                function safeJump(spriteName, frames, fps) {
                    if (frames > 1 && fps > 1) {
                        jumpTo(spriteName)
                    } else {
                        console.log("Animation blocked: too few frames or fps")
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: {
            if (spriteLoader.item && spriteLoader.item.spriteObj) {
                spriteLoader.item.spriteObj.safeJump(
                    "press",
                    plasmoid.configuration.pressFrameCount,
                    plasmoid.configuration.pressFrameRate
                )
            }
        }
    }
}
