
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/at86rf215_tx_v3_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "DATA_RATE" -widget comboBox
  ipgui::add_param $IPINST -name "TXD_WIDTH"
  set FRACTIONAL_BITS [ipgui::add_param $IPINST -name "FRACTIONAL_BITS"]
  set_property tooltip {Aligns the input to include one sign bit.} ${FRACTIONAL_BITS}
  set GPIO_MARK_SYNC [ipgui::add_param $IPINST -name "GPIO_MARK_SYNC"]
  set_property tooltip {Determines where the embedded control will be supplied from.} ${GPIO_MARK_SYNC}
  set PACKET_MODE [ipgui::add_param $IPINST -name "PACKET_MODE"]
  set_property tooltip {If in packet mode a 32 bit init string will always be sent.} ${PACKET_MODE}
  ipgui::add_param $IPINST -name "INVERT_OUTPUT"
  ipgui::add_param $IPINST -name "GPIO_SYNC_BITS"
  ipgui::add_param $IPINST -name "RECONFIGURABLE_INVERT"

}

proc update_PARAM_VALUE.RECONFIGURABLE_INVERT { PARAM_VALUE.RECONFIGURABLE_INVERT PARAM_VALUE.INVERT_OUTPUT } {
	# Procedure called to update RECONFIGURABLE_INVERT when any of the dependent parameters in the arguments change
	
	set RECONFIGURABLE_INVERT ${PARAM_VALUE.RECONFIGURABLE_INVERT}
	set INVERT_OUTPUT ${PARAM_VALUE.INVERT_OUTPUT}
	set values(INVERT_OUTPUT) [get_property value $INVERT_OUTPUT]
	if { [gen_USERPARAMETER_RECONFIGURABLE_INVERT_ENABLEMENT $values(INVERT_OUTPUT)] } {
		set_property enabled true $RECONFIGURABLE_INVERT
	} else {
		set_property enabled false $RECONFIGURABLE_INVERT
	}
}

proc validate_PARAM_VALUE.RECONFIGURABLE_INVERT { PARAM_VALUE.RECONFIGURABLE_INVERT } {
	# Procedure called to validate RECONFIGURABLE_INVERT
	return true
}

proc update_PARAM_VALUE.TXD_WIDTH { PARAM_VALUE.TXD_WIDTH PARAM_VALUE.DATA_RATE } {
	# Procedure called to update TXD_WIDTH when any of the dependent parameters in the arguments change
	
	set TXD_WIDTH ${PARAM_VALUE.TXD_WIDTH}
	set DATA_RATE ${PARAM_VALUE.DATA_RATE}
	set values(DATA_RATE) [get_property value $DATA_RATE]
	set_property value [gen_USERPARAMETER_TXD_WIDTH_VALUE $values(DATA_RATE)] $TXD_WIDTH
}

proc validate_PARAM_VALUE.TXD_WIDTH { PARAM_VALUE.TXD_WIDTH } {
	# Procedure called to validate TXD_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_RATE { PARAM_VALUE.DATA_RATE } {
	# Procedure called to update DATA_RATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_RATE { PARAM_VALUE.DATA_RATE } {
	# Procedure called to validate DATA_RATE
	return true
}

proc update_PARAM_VALUE.FRACTIONAL_BITS { PARAM_VALUE.FRACTIONAL_BITS } {
	# Procedure called to update FRACTIONAL_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRACTIONAL_BITS { PARAM_VALUE.FRACTIONAL_BITS } {
	# Procedure called to validate FRACTIONAL_BITS
	return true
}

proc update_PARAM_VALUE.GPIO_MARK_SYNC { PARAM_VALUE.GPIO_MARK_SYNC } {
	# Procedure called to update GPIO_MARK_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GPIO_MARK_SYNC { PARAM_VALUE.GPIO_MARK_SYNC } {
	# Procedure called to validate GPIO_MARK_SYNC
	return true
}

proc update_PARAM_VALUE.GPIO_SYNC_BITS { PARAM_VALUE.GPIO_SYNC_BITS } {
	# Procedure called to update GPIO_SYNC_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GPIO_SYNC_BITS { PARAM_VALUE.GPIO_SYNC_BITS } {
	# Procedure called to validate GPIO_SYNC_BITS
	return true
}

proc update_PARAM_VALUE.INVERT_OUTPUT { PARAM_VALUE.INVERT_OUTPUT } {
	# Procedure called to update INVERT_OUTPUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INVERT_OUTPUT { PARAM_VALUE.INVERT_OUTPUT } {
	# Procedure called to validate INVERT_OUTPUT
	return true
}

proc update_PARAM_VALUE.PACKET_MODE { PARAM_VALUE.PACKET_MODE } {
	# Procedure called to update PACKET_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_MODE { PARAM_VALUE.PACKET_MODE } {
	# Procedure called to validate PACKET_MODE
	return true
}


proc update_MODELPARAM_VALUE.DATA_RATE { MODELPARAM_VALUE.DATA_RATE PARAM_VALUE.DATA_RATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_RATE}] ${MODELPARAM_VALUE.DATA_RATE}
}

proc update_MODELPARAM_VALUE.TXD_WIDTH { MODELPARAM_VALUE.TXD_WIDTH PARAM_VALUE.TXD_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TXD_WIDTH}] ${MODELPARAM_VALUE.TXD_WIDTH}
}

proc update_MODELPARAM_VALUE.FRACTIONAL_BITS { MODELPARAM_VALUE.FRACTIONAL_BITS PARAM_VALUE.FRACTIONAL_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRACTIONAL_BITS}] ${MODELPARAM_VALUE.FRACTIONAL_BITS}
}

proc update_MODELPARAM_VALUE.GPIO_MARK_SYNC { MODELPARAM_VALUE.GPIO_MARK_SYNC PARAM_VALUE.GPIO_MARK_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GPIO_MARK_SYNC}] ${MODELPARAM_VALUE.GPIO_MARK_SYNC}
}

proc update_MODELPARAM_VALUE.PACKET_MODE { MODELPARAM_VALUE.PACKET_MODE PARAM_VALUE.PACKET_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_MODE}] ${MODELPARAM_VALUE.PACKET_MODE}
}

proc update_MODELPARAM_VALUE.INVERT_OUTPUT { MODELPARAM_VALUE.INVERT_OUTPUT PARAM_VALUE.INVERT_OUTPUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INVERT_OUTPUT}] ${MODELPARAM_VALUE.INVERT_OUTPUT}
}

proc update_MODELPARAM_VALUE.GPIO_SYNC_BITS { MODELPARAM_VALUE.GPIO_SYNC_BITS PARAM_VALUE.GPIO_SYNC_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GPIO_SYNC_BITS}] ${MODELPARAM_VALUE.GPIO_SYNC_BITS}
}

proc update_MODELPARAM_VALUE.RECONFIGURABLE_INVERT { MODELPARAM_VALUE.RECONFIGURABLE_INVERT PARAM_VALUE.RECONFIGURABLE_INVERT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RECONFIGURABLE_INVERT}] ${MODELPARAM_VALUE.RECONFIGURABLE_INVERT}
}

