# SSD Clock
set_property package_pin E3 [get_ports SSDClk]
set_property iostandard LVCMOS33 [get_ports SSDClk]

# Button Clock
set_property package_pin N17 [get_ports clk]
set_property iostandard LVCMOS33 [get_ports clk]

# Reset Button
set_property package_pin M18 [get_ports rst]
set_property iostandard LVCMOS33 [get_ports rst]

# Slide buttons (for the 16 LEDs)
set_property package_pin J15 [get_ports {LEDSel[0]}]
set_property iostandard LVCMOS33 [get_ports {LEDSel[0]}]

set_property package_pin L16 [get_ports {LEDSel[1]}]
set_property iostandard LVCMOS33 [get_ports {LEDSel[1]}]

# set_property package_pin M13 [get_ports {a[2]}]
# set_property iostandard LVCMOS33 [get_ports {a[2]}]

# Slide buttons selectors for the SSD
set_property package_pin R15 [get_ports {SSDSel[0]}]
set_property iostandard LVCMOS33 [get_ports {SSDSel[0]}]

set_property package_pin R17 [get_ports {SSDSel[1]}]
set_property iostandard LVCMOS33 [get_ports {SSDSel[1]}]

set_property package_pin T18 [get_ports {SSDSel[2]}]
set_property iostandard LVCMOS33 [get_ports {SSDSel[2]}]

set_property package_pin U18 [get_ports {SSDSel[3]}]
set_property iostandard LVCMOS33 [get_ports {SSDSel[3]}]

# set_property package_pin R13 [get_ports {a[7]}]
# set_property iostandard LVCMOS33 [get_ports {a[7]}]

#Unused slide buttons (for 8-bit input)

# set_property package_pin T8 [get_ports {b[0]}]
# set_property iostandard LVCMOS33 [get_ports {b[0]}]

# set_property package_pin U8 [get_ports {b[1]}]
# set_property iostandard LVCMOS33 [get_ports {b[1]}]

# set_property package_pin R16 [get_ports {b[2]}]
# set_property iostandard LVCMOS33 [get_ports {b[2]}]

# set_property package_pin T13 [get_ports {b[3]}]
# set_property iostandard LVCMOS33 [get_ports {b[3]}]

# set_property package_pin H6 [get_ports {b[4]}]
# set_property iostandard LVCMOS33 [get_ports {b[4]}]

# set_property package_pin U12 [get_ports {b[5]}]
# set_property iostandard LVCMOS33 [get_ports {b[5]}]

# set_property package_pin U11 [get_ports {b[6]}]
# set_property iostandard LVCMOS33 [get_ports {b[6]}]

# set_property package_pin V10 [get_ports {b[7]}]
# set_property iostandard LVCMOS33 [get_ports {b[7]}]

# Anode selector
set_property package_pin J14 [get_ports {Anode[3]}]
set_property iostandard LVCMOS33 [get_ports {Anode[3]}]

set_property package_pin T9 [get_ports {Anode[2]}]
set_property iostandard LVCMOS33 [get_ports {Anode[2]}]

set_property package_pin J18 [get_ports {Anode[1]}]
set_property iostandard LVCMOS33 [get_ports {Anode[1]}]

set_property package_pin J17 [get_ports {Anode[0]}]
set_property iostandard LVCMOS33 [get_ports {Anode[0]}]


# LED segments
set_property package_pin T10 [get_ports {LED_out[6]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[6]}]

set_property package_pin R10 [get_ports {LED_out[5]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[5]}]

set_property package_pin K16 [get_ports {LED_out[4]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[4]}]

set_property package_pin K13 [get_ports {LED_out[3]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[3]}]

set_property package_pin P15 [get_ports {LED_out[2]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[2]}]

set_property package_pin T11 [get_ports {LED_out[1]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[1]}]

set_property package_pin L18 [get_ports {LED_out[0]}]
set_property iostandard LVCMOS33 [get_ports {LED_out[0]}]

# LED outputs
set_property package_pin H17 [get_ports {LED[0]}]
set_property iostandard LVCMOS33 [get_ports {LED[0]}]

set_property package_pin K15 [get_ports {LED[1]}]
set_property iostandard LVCMOS33 [get_ports {LED[1]}]

set_property package_pin J13 [get_ports {LED[2]}]
set_property iostandard LVCMOS33 [get_ports {LED[2]}]

set_property package_pin N14 [get_ports {LED[3]}]
set_property iostandard LVCMOS33 [get_ports {LED[3]}]

set_property package_pin R18 [get_ports {LED[4]}]
set_property iostandard LVCMOS33 [get_ports {LED[4]}]

set_property package_pin V17 [get_ports {LED[5]}]
set_property iostandard LVCMOS33 [get_ports {LED[5]}]

set_property package_pin U17 [get_ports {LED[6]}]
set_property iostandard LVCMOS33 [get_ports {LED[6]}]

set_property package_pin U16 [get_ports {LED[7]}]
set_property iostandard LVCMOS33 [get_ports {LED[7]}]

set_property PACKAGE_PIN V16 [get_ports {LED[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]

set_property PACKAGE_PIN T15 [get_ports {LED[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]

set_property PACKAGE_PIN U14 [get_ports {LED[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]

set_property PACKAGE_PIN T16 [get_ports {LED[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]

set_property PACKAGE_PIN V15 [get_ports {LED[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]

set_property PACKAGE_PIN V14 [get_ports {LED[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]

set_property PACKAGE_PIN V12 [get_ports {LED[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]

set_property PACKAGE_PIN V11 [get_ports {LED[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]

