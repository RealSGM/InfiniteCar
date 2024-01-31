extends Node

signal fade_finished

func disconnect_signal(signal_name,nodepath,method):
	disconnect(signal_name,nodepath,method)

func connect_signal(signal_name,nodepath,method):
	var _err = connect(signal_name,nodepath,method)
