package justTriangles;
import justTriangles.Point;
import justTriangles.Triangle;
class SevenSeg{
    public var width:  Float = 0.10;
    public var height: Float = 0.18;
    public var unit: Float   = 0.01;
    public var colorID: Int  = 0;
    public var id: Int;
    public var outline: Bool = true;
    public var x: Float;
    public var y: Float;
    public var gap: Float;
    
    // example use, for simple LED type number display.
    // var sevenSeg = new SevenSeg( 1, 1, 0.200, 0.320 );
    // sevenSeg.createHex( 8, 0, 0 );
    //
    public function new( id_: Int, colorID_: Int
                        ,  width_: Float, height_: Float ){
        id = id_;
        colorID = colorID_;
        height = height_;
        width  = width_;
        unit = width_ * (1/10);
        gap = unit/5;
    } 
    
    public function add( hexCode: Int, x_: Float, y_: Float ){
        x = x_;
        y = y_;
        switch( hexCode ){
            case 0:
                a();
                b();
                c();
                d();
                e();
                f();
            case 1:
                b();
                c();
            case 2:
                a();
                b();
                g();
                c();
                d();
            case 3:
                a();
                b();
                g();
                c();
                d();
            case 4:
                f();
                g();
                b();
                c();
            case 5:
            trace( '5 ');
                a();
                f();
                g();
                c();
                d();
            case 6:
                a();
                f();
                g();
                c();
                d();
                e();
            case 7:
                a();
                b();
                c();
            case 8:
                a();
                b();
                c();
                d();
                e();
                f();
                g();
            case 9: 
                g();
                f();
                a();
                b();
                c();
            case 10: // A
                e();
                f();
                a();
                b();
                c();
                g();
            case 11: // b
                f();
                g();
                c();
                d();
                e();
            case 12: // C
                a();
                f();
                e();
                d();
            case 13: // d
                b();
                g();
                e();
                d();
                c();
            case 14: // E
                a();
                f();
                g();
                e();
                d();
            case 15: // F
                a();
                f();
                g();
                e();
        }
    }
    
    inline function a(){
        horiSeg( x, y );
    }
    inline function b(){
        vertSeg( x + width - 2*unit, y );
    }
    inline function c(){
        var hi = height/2;
        vertSeg( x + width - 2*unit, y + hi - unit );
    }
    inline function d(){
        horiSeg( x, y + height - 2*unit );
    }
    inline function e(){
        var hi = height/2;
        vertSeg( x, y + hi - unit );
    }
    inline function f(){
        vertSeg( x, y );
    }
    inline function g(){
        var hi = height/2;
        horiSeg( x, y + hi - unit );
    }
    inline function dp(){
        // not implemented
    }
    inline function horiSeg( x_, y_ ){
        var tri = Triangle.triangles;
        var l = tri.length;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit + gap, y: y_ + unit }
                        , { x: x_ + 2*unit, y: y_ }
                        , { x: x_ + width - unit - gap, y: y_ + unit }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + 2*unit, y: y_ }
                        , { x: x_ + width - 2*unit, y: y_ }
                        , { x: x_ + width - unit - gap, y: y_ + unit }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit + gap, y: y_ + unit }
                        , { x: x_ + width - unit - gap, y: y_  + unit }
                        , { x: x_ + width - 2*unit, y: y_ + 2*unit }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit + gap, y: y_ + unit }
                        , { x: x_ + width - 2*unit, y: y_  + 2*unit }
                        , { x: x_ + 2*unit, y: y_ + 2*unit }
                        , 0
                        , colorID );
    }
    inline function vertSeg( x_, y_ ){
        var tri = Triangle.triangles;
        var l = tri.length;
        var hi = height/2;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_, y: y_ + 2*unit }
                        , { x: x_ + unit, y: y_ + hi - gap }
                        , { x: x_, y: y_ + hi - unit + gap }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_, y: y_ + 2*unit }
                        , { x: x_ + unit, y: y_ + unit + gap }
                        , { x: x_ + unit, y: y_ + hi - gap }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit, y: y_ + unit + gap }
                        , { x: x_ + 2*unit, y: y_  + hi - unit }
                        , { x: x_ + unit, y: y_ + hi - gap }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit, y: y_ + unit + gap }
                        , { x: x_ + 2*unit, y: y_  + 2*unit }
                        , { x: x_ + 2*unit, y: y_ + hi - unit }
                        , 0
                        , colorID );
    }
}
