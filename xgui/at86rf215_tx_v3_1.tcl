# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "TXD_WIDTH"
  set FRACTIONAL_BITS [ipgui::add_param $IPINST -name "FRACTIONAL_BITS"]
  set_property tooltip {Aligns the input to include one sign bit.} ${FRACTIONAL_BITS}

}

proc update_PARAM_VALUE.FRACTIONAL_BITS { PARAM_VALUE.FRACTIONAL_BITS } {
	# Procedure called to update FRACTIONAL_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRACTIONAL_BITS { PARAM_VALUE.FRACTIONAL_BITS } {
	# Procedure called to validate FRACTIONAL_BITS
	return true
}

proc update_PARAM_VALUE.TXD_WIDTH { PARAM_VALUE.TXD_WIDTH } {
	# Procedure called to update TXD_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TXD_WIDTH { PARAM_VALUE.TXD_WIDTH } {
	# Procedure called to validate TXD_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.TXD_WIDTH { MODELPARAM_VALUE.TXD_WIDTH PARAM_VALUE.TXD_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TXD_WIDTH}] ${MODELPARAM_VALUE.TXD_WIDTH}
}

proc update_MODELPARAM_VALUE.FRACTIONAL_BITS { MODELPARAM_VALUE.FRACTIONAL_BITS PARAM_VALUE.FRACTIONAL_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRACTIONAL_BITS}] ${MODELPARAM_VALUE.FRACTIONAL_BITS}
}

