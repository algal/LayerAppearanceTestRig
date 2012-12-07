This rig shows how a view.layer's properties affects the view's properties and appearance.  Set the view.layer's properties, call setNeedsDisplay, and see the results. Labels values update automatically.

view.layer has:
- a background "color" image defined with +[UIColor colorWithImagePattern:]
- a CAShapeLayer sublayer with red circle centred on the bottom-right
- an (optional) mask layer with a small centered circle

Notable:
- layer.cornerRadius masks the layer's background (even when masksToBounds=NO)
- layer.cornerRadius also masks the layer's contents (when masksToBounds=YES)
- layer.masksToBounds=YES masks out any drop shadows, since they lie outside the bounds
- layer.masksToBounds and view.clipsToBounds are equivalent
- layer.opacity and view.alpha are equivalent
- layer.backgroundColor and view.backgroundColor are equivalent
- layer.opaque and view.opaque are NOT equivalent; layer.opaque is strange. My understanding: view.opaque is a hint to UIKit, which will never change appearance, but presumably could worsen perf if the hint is inaccurate. layer.opaque can change the appearance, since it actually affects what kind of graphics context is used to build the layer's bitmap. 

Properties which require "offscreen rendering":
- shouldRasterize, cornerRadius, shadowOpacity, masking-to-a-circle-layer (but not bounds), shadowOpacity (when without a shadowPath)

Properties which require "blended layers":
- cornerRadius, opacity (also known as view.alpha)

Things I don't understand:
- about offscreen-rendering (yellow), blended layers (red/green), "fast path" (blue):
- what EXACTLY is expensive to the GPU? to the CPU? 
- which one matters for initial rendering time? for smooth animation? for responsive scrolling?

- how does shouldRasterize do any bitmap caching not already done by UIKit's normal lazy approach to calling displayIfNeeded?
-- is that UIKit is unaware of CALayer properties like cornerRadius, shadowOpacity, etc., and that by default setting these properties results in quartz constantly redrawing?!



