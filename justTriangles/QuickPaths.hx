package justTriangles;
import justTriangles.QuickPaths;
// Class to fill with useful PathContext drawings, mostly for testing.
class QuickPaths {
    public function new(){}
        
    // TODO: refactor to be more generic?
    // quadTo quadratic curve test
    public static inline function heart( ctx: PathContext ):Void {
        ctx.moveTo(75,25);
        ctx.quadTo(25,25,25,62.5);
        ctx.quadTo(25,100,50,100);
        ctx.quadTo(50,120,30,125);
        ctx.quadTo(60,120,65,100);
        ctx.quadTo(125,100,125,62.5);
        ctx.quadTo(125,25,75,25);
    }
    // TODO: refactor to be more generic?
    // curveTo cubic curve test
    public static inline function speechBubble( ctx: PathContext ):Void {
        ctx.moveTo(75,40);
        ctx.curveTo(75,37,70,25,50,25);
        ctx.curveTo(20,25,20,62.5,20,62.5);
        ctx.curveTo(20,80,40,102,75,120);
        ctx.curveTo(110,102,130,80,130,62.5);
        ctx.curveTo(130,62.5,130,25,100,25);
        ctx.curveTo(85,25,75,37,75,40);
    }
}
