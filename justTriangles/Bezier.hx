package justTriangles;
class Bezier {
    public inline static function quadratic ( t: Float
                                                    , startPoint: Float
                                                    , controlPoint: Float
                                                    , endPoint: Float
                                                    ): Float {
        var u = 1 - t;
        return Math.pow( u, 2 ) * startPoint + 2 * u * t * controlPoint + Math.pow( t, 2 ) * endPoint;
    }
    public inline static function cubic( t:                Float
                                , startPoint:       Float
                                , controlPoint1:    Float
                                , controlPoint2:    Float
                                , endPoint:         Float 
                                ): Float {
        var u = 1 - t;
        return  Math.pow( u, 3 ) * startPoint + 3 * Math.pow( u, 2 ) * t * controlPoint1 +
                3* u * Math.pow( t, 2 ) * controlPoint2 + Math.pow( t, 3 ) * endPoint;
    }
}

