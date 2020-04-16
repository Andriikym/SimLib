/**
*  SimLib
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import CoreLocation

extension CLLocationCoordinate2D {
    var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self)
            && !(self.latitude == 0.0 && self.longitude == 0.0)
    }
}
