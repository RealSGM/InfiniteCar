extends Node

var large_buildings = ["res://Assets/KenneyCity/large_buildingA.dae", "res://Assets/KenneyCity/large_buildingB.dae", "res://Assets/KenneyCity/large_buildingC.dae", "res://Assets/KenneyCity/large_buildingD.dae", "res://Assets/KenneyCity/large_buildingE.dae", "res://Assets/KenneyCity/large_buildingF.dae", "res://Assets/KenneyCity/large_buildingG.dae"]
var small_buildings = ["res://Assets/KenneyCity/small_buildingA.dae", "res://Assets/KenneyCity/small_buildingB.dae", "res://Assets/KenneyCity/small_buildingC.dae", "res://Assets/KenneyCity/small_buildingD.dae", "res://Assets/KenneyCity/small_buildingE.dae", "res://Assets/KenneyCity/small_buildingF.dae"]
var skyscrapers = ["res://Assets/KenneyCity/skyscraperA.dae", "res://Assets/KenneyCity/skyscraperB.dae", "res://Assets/KenneyCity/skyscraperC.dae", "res://Assets/KenneyCity/skyscraperD.dae", "res://Assets/KenneyCity/skyscraperE.dae", "res://Assets/KenneyCity/skyscraperF.dae"]
var buildings_prob = []

var large_buildings_loaded = []
var small_buildings_loaded = []
var skyscrapers_loaded = []


func load_buildings():
	for building in large_buildings:
		large_buildings_loaded.append(load(building))
	for building in small_buildings:
		small_buildings_loaded.append(load(building))
	for building in skyscrapers:
		skyscrapers_loaded.append(load(building))
	buildings_prob = [small_buildings_loaded,small_buildings_loaded,small_buildings_loaded,large_buildings_loaded,skyscrapers_loaded]
	
