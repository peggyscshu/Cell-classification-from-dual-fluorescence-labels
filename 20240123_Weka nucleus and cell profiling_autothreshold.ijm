//Preparation
	tifName = getTitle();
	Name = replace(tifName, ".lof", "");
	path = getDirectory("image");
	rename("Raw");
	run("Duplicate...", "duplicate");
	selectWindow("Raw-1");
	run("Split Channels");
//Process Nucleus channel for ML
	selectWindow("C1-Raw-1");
	rename("Nucleus");
	run("Median...", "radius=2");
	run("Median...", "radius=2");
	run("Subtract Background...", "rolling=1000");
	setMinAndMax(0, 29);
	saveAs("Tiff", path+ File.separator + "Nucleus for Weka.tif");
//Weka classification
	run("Trainable Weka Segmentation");
	wait(3000);
	selectImage("Trainable Weka Segmentation v3.3.4");
	call("trainableSegmentation.Weka_Segmentation.loadClassifier", path + File.separator + "classifier.model");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", path, "Nucleus for Weka.tif", "showResults=true", "storeResults=false", "probabilityMaps=false", "");
//Get nucleus ROI list
	selectWindow("Classification result");
	setThreshold(0, 0, "raw");
	run("Analyze Particles...", "size=3-Infinity add");
	roiManager("Save", path + File.separator + "RoiNucleus.zip");
//Clear
	selectImage("Trainable Weka Segmentation v3.3.4");
	close();
	selectImage("Classification result");
	close();
	selectImage("Nucleus for Weka.tif");
	close();
//Red channel
	selectWindow("C2-Raw-1");
	rename("Red");
	selectWindow("Red");
	run("Gaussian Blur...", "sigma=2");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
	run("Subtract Background...", "rolling=20");
	setAutoThreshold("Otsu dark");
	run("Convert to Mask");
	run("Divide...", "value=255");
//Green channel
	selectWindow("C3-Raw-1");
	rename("Green");
	selectWindow("Green");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
	run("Subtract Background...", "rolling=10");
	setAutoThreshold("MaxEntropy dark");
	run("Convert to Mask");
	run("Divide...", "value=255");
//Cell Profiling
	run("Set Measurements...", "min redirect=None decimal=2");
	selectWindow("Red");
	run("Invert LUT");
	run("Enhance Contrast", "saturated=0.35");
	roiManager("Show All without labels");
	roiManager("Measure");
	Table.deleteColumn("Min");
	Array_R = Table.getColumn("Max");
	print(Array_R[2155]);
	run("Clear Results");
	roiManager("Show None");
	selectWindow("Green");
	run("Invert LUT");
	run("Enhance Contrast", "saturated=0.35");
	roiManager("Show All without labels");
	roiManager("Measure");
	Array_G = Table.getColumn("Max");
	run("Clear Results");
	roiManager("Show None");
	Array_ID = newArray(0);
	c = roiManager("count");
	for (i = 0; i < c; i++) {
		id = i+1;
		Array_ID = Array.concat(Array_ID,id);
	}
	Table.create("Cell Profile");
	Table.setColumn("ID", Array_ID);
	Table.setColumn("Red positive", Array_R);
	Table.setColumn("Green positive", Array_G);
//Judge Colocalization
	Array_Sum= newArray(0);
	for (i = 0; i < Array_R.length; i++) {
		a = Array_R[i] + Array_G[i];
		Array_Sum = Array.concat(Array_Sum,a);
	}
	Array_Col= newArray(0);
	for (i = 0; i < Array_Sum.length; i++) {
		if (Array_Sum[i]==2) {
			Array_Col = Array.concat(Array_Col,1);
		}
		else {
			Array_Col = Array.concat(Array_Col,0);
		}
	}
	Table.setColumn("Red and Green Colocalized cell", Array_Col);
//Calculate cell no.
	Array_R = Table.getColumn("Red positive");
	Array_G = Table.getColumn("Green positive");
	Array_Col = Table.getColumn("Red and Green Colocalized cell");
	R = 0;
	G = 0;
	Col = 0;
	for (i = 0; i < Array_R.length; i++) {
		R = R + Array_R[i];
		G = G + Array_G[i];
		Col = Col + Array_Col[i];
	}
	print(tifName + "    Red positive cells : " + R );
	print(tifName + "    Green positive cells : " + G );
	print(tifName + "    Colocalized cells : " + Col );
	print(tifName + "    Total cell no : " + Array_R.length );

//Inspection
	selectWindow("Raw");
	setSlice(1);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(2);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(3);
	setMinAndMax(15, 44);
	//roiManager("Show All");
//Clear
	selectWindow("Red");
	close();
	selectWindow("Green");
	close();
	selectImage("Nucleus for Weka.tif");
	close();
