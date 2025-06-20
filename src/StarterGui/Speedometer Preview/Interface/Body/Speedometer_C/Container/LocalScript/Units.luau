local STUDS_PER_MILE = 5280
local HOUR_SECONDS = 3600

local Units = {}

function Units.studsToMiles(studs: number): number
	return studs / STUDS_PER_MILE
end

function Units.milesToStuds(miles: number): number
	return miles * STUDS_PER_MILE
end

function Units.studsPerSecondToMilesPerHour(studsPerSecond: number): number
	local milesPerSecond = Units.studsToMiles(studsPerSecond)
	local milesPerHour = milesPerSecond * HOUR_SECONDS
	return milesPerHour
end

function Units.milesPerHourToStudsPerSecond(milesPerHour: number): number
	local studsPerHour = Units.milesToStuds(milesPerHour)
	local studsPerSecond = studsPerHour / HOUR_SECONDS
	return studsPerSecond
end

function Units.studsToKilometersPerHour(studs: number): number
	local miles = Units.studsToMiles(studs)
	local kilometers = miles * 1.60934
	local kilometersPerHour = kilometers * HOUR_SECONDS
	return kilometersPerHour
end

	

return Units


