
; Smart Remove

; Smart selection eraser.
; Requires resynthesizer plug-in.
; Paul Harrison (pfh@logarithmic.net)

; Versions
; lloyd konneker lkk 3/29/2009 Fix passing workLayerID to plugin.  
; Other non-functional changes: comments, error checking, menu item, blurb, license
;

; License:
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; The GNU Public License is available at
; http://www.gnu.org/copyleft/gpl.html

; lkk comment: creates stencil selection in a temp dupe image to pass as source drawable to plugin


(define (script-fu-smart-remove img layer corpus-border)
  (cond
    ((= 0 (car (gimp-selection-bounds img))) 
      (gimp-message "To use this script-fu, first select the region you wish to remove.")
    )
    (#t (let*
      (
        (dupe (car (gimp-image-duplicate img)))
        (channel (car (gimp-selection-save dupe)))
        (workLayerID -1)    ; lkk
      )

      ; lkk flatten (so stencil gets everything visible) and to activate a layer in dupe
      ; (gimp-message-set-handler 1)	; debug messages to console
      (gimp-image-flatten dupe)         ; lkk !!! flatten, activates layer, but deletes alpha
      (set! workLayerID (car (gimp-image-get-active-layer dupe)))
      (cond ((= -1 workLayerID) 
           (gimp-message "Failed get active layer")
      )     )
      ; lkk plugin requires equal count of channels, target and source.  Plugin should be changed to relax this reqt.
      (cond ((= 1 (car (gimp-drawable-has-alpha layer)))
           ;debug (gimp-message "Adding alpha")
           (if (not (car (gimp-layer-add-alpha workLayerID)))  (gimp-message "Failed add alpha") )
      )     )
      
      
      ; lkk comment: grow selection, invert, save to channel2, cut a hole size of orig selection
      ; lkk in the grown selection in channel2, select channel2, un invert
      (gimp-selection-grow dupe corpus-border)
      (gimp-selection-invert dupe)
      (let*
        (
	      (old-background (car (gimp-context-get-background)))
          (channel2 (car (gimp-selection-save dupe)))
        )

        (gimp-selection-load channel)
	    (gimp-context-set-background '(255 255 255))
        (if (not (car (gimp-edit-clear channel2))) (gimp-message "Failed edit clear") )
	    (gimp-context-set-background old-background)
        (gimp-selection-load channel2)
      )

      (gimp-selection-invert dupe)
      ; lkk comment: crop the dupe to size of stencil to save memory
      (let*
        (
          (bounds (gimp-selection-bounds dupe))
	      (x1 (nth 1 bounds))
	      (y1 (nth 2 bounds))
	      (x2 (nth 3 bounds))
	      (y2 (nth 4 bounds))
        )

        (gimp-image-crop dupe (- x2 x1) (- y2 y1) x1 y1)
      )

      (gimp-selection-invert dupe)  ; lkk !!! plugin requires inverted selection
      ;(gimp-display-new dupe)   ; debug to see the stencil as passed to plugin
      ;(gimp-displays-flush)     ; debug
      
      ; lkk originally 7th param was layer (the in layer), which only SEEMED to work.  Should be the stencil.
      (plug-in-resynthesizer 1 img layer 0 0 1 workLayerID -1 -1 0.0 0.117 16 500)

      (gimp-image-delete dupe)
      (gimp-displays-flush)
) ) ))

(script-fu-register "script-fu-smart-remove"
                    "<Image>/Filters/Enhance/Heal selection..."
		    "Extend surrounding texture to cover the selection.  Works best with homogenous, not regular surroundings. \
Requires separate resynthesizer plug-in."
		    "Paul Harrison (pfh@logarithmic.net)"
		    "Copyright 2000 Paul Harrison, 2009 Lloyd Konneker"
		    "13/9/2000"
		    "RGB* GRAY*"
		    SF-IMAGE "Input Image" 0
		    SF-DRAWABLE "Input Layer" 0
		    SF-ADJUSTMENT "Radius to take texture from" '(50 7 1000 1.0 1.0 0 1)
)

