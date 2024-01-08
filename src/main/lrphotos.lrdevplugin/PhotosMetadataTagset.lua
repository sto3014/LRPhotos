require  "PluginInit"

return{
	title = LOC "$$$/Photos/Metadata/Tagset/Title=Photos App",
	id = 'LRPhotosTagset',
	
	items = {
		{ 'com.adobe.label', label = LOC "$$$/Photos/Metadata/OrigLabel=Standard" },
		'com.adobe.filename',
		'com.adobe.folder',
		
		'com.adobe.separator',
		
		'com.adobe.title',
		{ 'com.adobe.caption', height_in_lines = 3 },

		'com.adobe.copyname',

		'com.adobe.separator',

		{ "com.adobe.copyrightState", pruneRedundantFields = false },

		"com.adobe.copyright",

		"com.adobe.source",

		'com.adobe.separator',
		{
			formatter = "com.adobe.label",
			label = LOC "$$$/Photos/Metadata/Tagset/Title=Photos App",
		},


		PluginInit.pluginID .. '.catalogName',

		PluginInit.pluginID .. '.localId',

		PluginInit.pluginID .. '.format',

		{PluginInit.pluginID .. '.photosId', height_in_lines = 3},

		PluginInit.pluginID .. '.mark',

		"com.adobe.separator",
		{
			formatter = "com.adobe.label",
			label = LOC "$$$/Photos/Metadata/ExifLabel=EXIF",
		},

		"com.adobe.imageFileDimensions",		-- dimensions
		"com.adobe.imageCroppedDimensions",

		"com.adobe.exposure",					-- exposure factors
		"com.adobe.brightnessValue",
		"com.adobe.exposureBiasValue",
		"com.adobe.flash",
		"com.adobe.exposureProgram",
		"com.adobe.meteringMode",
		"com.adobe.ISOSpeedRating",

		"com.adobe.focalLength",				-- lens info
		"com.adobe.focalLength35mm",
		"com.adobe.lens",
		"com.adobe.subjectDistance",

		"com.adobe.dateTimeOriginal",
		"com.adobe.dateTimeDigitized",
		"com.adobe.dateTime",

		"com.adobe.make",						-- camera
		"com.adobe.model",
		"com.adobe.serialNumber",

		"com.adobe.userComment",

		"com.adobe.artist",
		"com.adobe.software",

		"com.adobe.GPS",						-- gps
		"com.adobe.GPSAltitude",
		"com.adobe.GPSImgDirection",

	},
}
