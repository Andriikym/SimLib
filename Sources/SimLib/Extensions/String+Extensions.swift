/**
*  SimLib
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation

extension String {
    internal var simRuntimeString: String {
        split(separator: ".")
            .last
            .map(String.init)
            ?? "UNK"
    }
}
