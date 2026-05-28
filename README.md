# Adapted single-region R-ARIO model for transport-economic interdependencies analysis
**Adapted from R-ARIO code by Issa et al. (2025): https://github.com/0marissa/SR-ARIO** <br>
**Original program by Stephane Hallegatte (2014)** <br>

MATLAB codebase for quantifying post-disaster economic recovery for a single region. The code adapts the Refined Adaptive Regional Input–Output (R-ARIO) model to incorporate transportation-related disruptions through three mechanisms: (i) integrating labor constraints into productive capacity calculations, (ii) modeling dynamic sector-specific imports, and (iii) modeling dynamic sector-specific exports.

*License: GNU General Public License v3.0 (see LICENSE)*

## Key features
* **Labor constraints**: Incorporates sector-specific labor losses due to road network disruptions as exogenous inputs that jointly determine sectoral productive capacity together with productive capital through a Leontief production function.
* **Dynamic imports**: Incorporate time-dependent import changes caused by port disruptions into production calculations, replacing the constant import assumption in the original R-ARIO model.
* **Dynamic exports**: Incorporate time-dependent export changes caused by port disruptions into demand calculations, replacing the constant export assumption in the original R-ARIO model.

## Example overview
This repository contains the data for a test-run example.
