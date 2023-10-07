# OpenSCAD NUC5PPYB Case

[![MIT License](https://img.shields.io/github/license/too-gee/openscad-nuc5ppyb-case)](https://github.com/too-gee/openscad-nuc5ppyb-case/blob/main/LICENSE)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/too-gee/openscad-nuc5ppyb-case/main)

<div align="center">
  <img src="./images/case.png" alt="Case Image" width="600" />
</div>

This is a case for the Intel NUC5PPYB kit. The case can be printed with or without mounting tabs (for mounting to a flat surface) and with a range of wall thicknesses.

Many parameters are configurable via the customizer without editing any code.

<div align="center">
  <img src="./images/options.png" alt="Case Image" width="299" />
</div>

## Design Considerations

This case is designed to "dam" the exhaust side of the fan from the intake side. The intent is to prevent fresh air from mixing with exhaust air to maximize the efficiency of the cooling solution. The orientation of the board affords easy access to the RAM slot and the SATA connector with the lid open. The lid is heavily perforated to allow for passive cooling of the cooler components.

Due to the orientation of the motherboard, this case does not have an integrated power button. Instead, a hole on the right side of the front panel is available for a dedicated power button. This can either be a simple momentary NO switch or a fancier switch with integrated LEDs to indicate power and drive activity.

This case design does not currently accomodate an internal SATA SSD since I do not have the standard NUC data + power connector. Whatever connector you have on hand can be routed out the side hole of this case.

There are no dividers between the top and bottom USB ports. These dividers were fragile when printed and served little practical or aesthetic purpose.

