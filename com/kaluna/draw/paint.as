package {
    import flash.display.MovieClip
    import flash.events.MouseEvent
	import flash.text.engine.TextBlock;
	
    public class Paint extends MovieClip {

		private const STAGE_WIDTH:int = 400
		private const STAGE_HEIGHT:int = 448
		private var colorList:Array
		private var colorButtonList:Array
		private var ticknessList:Array
		private var ticknessButtonList:Array
        private var canvas:Canvas
		
		public function Paint():void {
            init()
            drawInterface()
		}

        private function init():void {
            canvas = new Canvas()
            colorButtonList = new Array()
			ticknessButtonList = new Array()
			
            colorList = 
                [0x000000, 0x808080, 
                 0x800000, 0x808000, 
                 0x008000, 0x008080, 
                 0x000080, 0x800080, 
                 0x808040, 0x004040, 
                 0x0080FF, 0x004080, 
                 0x8000FF, 0x804000, 
                 0xFFFFFF, 0xC0C0C0, 
                 0xFF0000, 0xFFFF00, 
                 0x00FF00, 0x00FFFF, 
                 0x0000FF, 0xFF00FF, 
                 0xFFFF80, 0x00FF80, 
                 0x80FFFF, 0x8080FF, 
                 0xFF0080, 0xFF8040]
			
			ticknessList = [1, 4, 8, 12]
        }

        private function drawInterface():void {
			graphics.beginFill(0xFFCC00)
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT)
			graphics.endFill()
			
            var cb:ColorButton

            for (var i:int = 0; i < 14; i++) {
                cb = new ColorButton(colorList[i], this)
                cb.x = 18 * i + 2
                cb.y = 2
				colorButtonList.push(cb)
                addChild(cb)
            }

            for (i = 14; i < 28; i++) {
                cb = new ColorButton(colorList[i], this)
                cb.x = 18 * (i - 14) + 2
                cb.y = 25
				colorButtonList.push(cb)
                addChild(cb)
            }
            
			var tb:TicknessButton
			
			for (i = 0; i < 4; i++) {
				tb = new TicknessButton(ticknessList[i], this)
				tb.x = 32 * (i + 14) + 2 - 184
				tb.y = 12
				ticknessButtonList.push(tb)
				addChild(tb)
			}
			
			colorButtonList[0].graphics.lineStyle(2, 0x000000)
			colorButtonList[0].graphics.drawRect(1, 1, 14, 19)
			
			ticknessButtonList[0].graphics.lineStyle(1, 0x000000)
			ticknessButtonList[0].graphics.drawCircle(12, 12, 12)
			
            canvas.x = 2
            canvas.y = 48
            canvas.graphics.lineStyle(1, 0x000000)
            canvas.graphics.beginFill(0xFFFFFF)
            canvas.graphics.drawRect(0, 0, STAGE_WIDTH - 5, STAGE_HEIGHT - 51)
            canvas.graphics.endFill()
            addChild(canvas)
        }
        
        public function setColor(color:uint):void {
            canvas.setColor(color)
        }
		
		public function unselectColorButtons():void {
			for (var i:int = 0; i < colorButtonList.length; i++) {
				colorButtonList[i].unselect()
			}
		}
		
		public function unselectTicknessButtons():void {
			for (var i:int = 0; i < ticknessButtonList.length; i++) {
				ticknessButtonList[i].unselect()
			}
		}
		
		public function setTickness(tickness:int):void {
            canvas.setTickness(tickness)
        }
    }
} 

import flash.display.MovieClip
import flash.events.MouseEvent

class ColorButton extends MovieClip {
    
    private var color:uint
    private var parentMC:Paint

    public function ColorButton(color:uint, parentMC:Paint) {
        this.color = color
        this.parentMC = parentMC
        buttonMode = true
        addEventListener(MouseEvent.CLICK, selectColor)

        drawButton()
    }

    private function selectColor(e:MouseEvent):void {
        parentMC.setColor(color)
		parentMC.unselectColorButtons()
		
		with(graphics) {
            lineStyle(2, 0x000000)
            beginFill(color)
            drawRect(1, 1, 14, 19)
            endFill()
        }
    }
	
	public function unselect():void {
		drawButton()
	}

    private function drawButton():void {
        with(graphics) {
            lineStyle(1, 0x000000)
            beginFill(color)
            drawRect(0, 0, 15, 20)
            endFill()
        }
    }
}

import flash.display.MovieClip
import flash.events.MouseEvent

class TicknessButton extends MovieClip {
    
    private var tickness:int
    private var parentMC:Paint

    public function TicknessButton(tickness:int, parentMC:Paint) {
        this.tickness = tickness
        this.parentMC = parentMC
        buttonMode = true
        addEventListener(MouseEvent.CLICK, selectTickness)

        drawButton()
    }

    private function selectTickness(e:MouseEvent):void {
        parentMC.setTickness(tickness)
		parentMC.unselectTicknessButtons()
		
		with (graphics) {
			lineStyle(1, 0x000000, 1)
			beginFill(0xFFFFFF)
			drawCircle(12, 12, 12)
			endFill()
            beginFill(0x000000)
            drawCircle(12, 12, tickness / 2 + 1)
            endFill()
        }
    }

	public function unselect():void {
		drawButton()
	}
	
    private function drawButton():void {
        with (graphics) {
			graphics.clear()
			//lineStyle(1, 0x000000, 0)
			beginFill(0xFFFFFF)
			drawCircle(12, 12, 12)
			endFill()
            beginFill(0x000000)
            drawCircle(12, 12, tickness / 2 + 1)
            endFill()
        }
    }
}

import flash.display.MovieClip
import flash.ui.Mouse

class Canvas extends MovieClip {

    private var tickness:int
    private var color:uint
    private var lastX:int
    private var lastY:int

    public function Canvas():void {
        tickness = 1
        color = 0x000000
        graphics.lineStyle(tickness, color)
		addEventListener(MouseEvent.MOUSE_DOWN, startPainting)
		addEventListener(MouseEvent.MOUSE_UP, stopPainting)
        addEventListener(MouseEvent.CLICK, drawPoint)
    }

    private function draw(e:MouseEvent):void {
        e.updateAfterEvent()
        graphics.lineStyle(tickness, color)
		graphics.lineTo(e.localX, e.localY)
    }
		
    private function startPainting(e:MouseEvent):void {
		addEventListener(MouseEvent.MOUSE_MOVE, draw)
		graphics.moveTo(e.localX, e.localY)
    }
		
    private function stopPainting(e:MouseEvent):void {
		removeEventListener(MouseEvent.MOUSE_MOVE, draw)
		graphics.moveTo(lastX, lastY)
		lastX = e.localX 
		lastY = e.localY
    }

    private function drawPoint(e:MouseEvent):void {
        graphics.lineStyle(tickness, color)
        graphics.moveTo(lastX, lastY)
        graphics.lineTo(lastX + 0.2, lastY + 0.2)
    }

    public function setColor(color:uint):void {
        this.color = color
        graphics.lineStyle(tickness, color)
    }
	
	public function setTickness(tickness:int):void {
        this.tickness = tickness
        graphics.lineStyle(tickness, color)
    }
}
