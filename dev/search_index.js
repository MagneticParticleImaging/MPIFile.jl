var documenterSearchIndex = {"docs":
[{"location":"positions.html#Positions","page":"Positions","title":"Positions","text":"","category":"section"},{"location":"positions.html","page":"Positions","title":"Positions","text":"MPIFiles contains several types describing point sets. ","category":"page"},{"location":"frequencyFilter.html#Frequency-Filter","page":"Frequency Filter","title":"Frequency Filter","text":"","category":"section"},{"location":"frequencyFilter.html","page":"Frequency Filter","title":"Frequency Filter","text":"A frequency filter can be calculated using the function","category":"page"},{"location":"frequencyFilter.html","page":"Frequency Filter","title":"Frequency Filter","text":"function filterFrequencies(f::MPIFile;\n                           SNRThresh=-1,\n                           minFreq=0, maxFreq=rxBandwidth(f),\n                           recChannels=1:rxNumChannels(f),\n                           sortBySNR=false,\n                           numUsedFreqs=-1,\n                           stepsize=1,\n                           maxMixingOrder=-1,\n                           sortByMixFactors=false)","category":"page"},{"location":"frequencyFilter.html","page":"Frequency Filter","title":"Frequency Filter","text":"Usually one will apply an SNR threshold SNRThresh > 1.5 and a minFreq that is larger than the excitation frequencies. The frequencies are specified in Hz. Also useful is the opportunity to select specific receive channels by specifying recChannels.","category":"page"},{"location":"frequencyFilter.html","page":"Frequency Filter","title":"Frequency Filter","text":"The return value of filterFrequencies is of type Vector{Int64} and can be directly passed to getMeasurements, getMeasurementsFD, and getSystemMatrix.","category":"page"},{"location":"conversion.html#Conversion","page":"Conversion","title":"Conversion","text":"","category":"section"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"With the support for reading different file formats and the ability to store data in the MDF, it is also possible to convert files into MDF. This can be done by calling","category":"page"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"saveasMDF(filenameOut, filenameIn)","category":"page"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"The second argument can alternatively also be an MPIFile handle.","category":"page"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"Alternatively, there is also a more low level interface which gives the user the control to change parameters before storing. This look like this","category":"page"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"params = loadDataset(f)\n# do something with params\nsaveasMDF(filenameOut, params)","category":"page"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"Here, f is an MPIFile handle and the command loadDataset loads the entire dataset including all parameters into a Julia Dict, which can be modified by the user. After modification one can store the data by passing the Dict as the second argument to the saveasMDF function.","category":"page"},{"location":"conversion.html","page":"Conversion","title":"Conversion","text":"note: Note\nThe parameters in the Dict returned by loadDataset have the same keys as the corresponding accessor functions listed in the Low Level Interface.","category":"page"},{"location":"systemmatrix.html#System-Matrices","page":"System Matrices","title":"System Matrices","text":"","category":"section"},{"location":"systemmatrix.html","page":"System Matrices","title":"System Matrices","text":"For loading the system matrix, one could in principle again call measData but there is again a high level function for this job. Since system functions can be very large it is crucial to load only the subset of frequencies that are used during reconstruction The high level system matrix loading function is called getSystemMatrix and has the following interface:","category":"page"},{"location":"systemmatrix.html","page":"System Matrices","title":"System Matrices","text":"function getSystemMatrix(f::MPIFile,\n                         frequencies=1:rxNumFrequencies(f)*rxNumChannels(f);\n                         bgCorrection=false,\n                         loadasreal=false,\n                         kargs...)","category":"page"},{"location":"systemmatrix.html","page":"System Matrices","title":"System Matrices","text":"loadasreal can again be used when using a solver requiring real numbers. The most important parameter is frequencies, which defaults to all possible frequencies over all receive channels. In practice, one will determine the frequencies using the the Frequency Filter functionality. The parameter bgCorrection controls if a  background correction is applied while loading the system matrix. The return value of getSystemMatrix is a matrix of type ComplexF32 or Float32 with the rows encoding the spatial dimension and the columns encoding the dimensions frequency, receive channels, and patches.","category":"page"},{"location":"reconstruction.html#Reconstruction-Results","page":"Reconstruction Results","title":"Reconstruction Results","text":"","category":"section"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"MDF files can also contain reconstruction results instead of measurement data. The low level results can be retrieved using the Low Level Interface","category":"page"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"function recoData(f::MPIFile)\nfunction recoFov(f::MPIFile)\nfunction recoFovCenter(f::MPIFile)\nfunction recoSize(f::MPIFile)\nfunction recoOrder(f::MPIFile)\nfunction recoPositions(f::MPIFile)","category":"page"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"Instead, one can also combine these data into an ImageMetadata object from the Images.jl package by calling the functions","category":"page"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"function loadRecoData(filename::AbstractString)","category":"page"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"The ImageMetadata object does also pull all relevant metadata from an MDF such that the file can be also be stored using","category":"page"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"function saveRecoData(filename, image::ImageMeta)","category":"page"},{"location":"reconstruction.html","page":"Reconstruction Results","title":"Reconstruction Results","text":"These two functions are especially relevant when using the package   MPIReco.jl","category":"page"},{"location":"lowlevel.html#Low-Level-Interface","page":"Low Level Interface","title":"Low Level Interface","text":"","category":"section"},{"location":"lowlevel.html","page":"Low Level Interface","title":"Low Level Interface","text":"The low level interface of MPIFiles.jl consists of a collection of methods that need to be implemented for each file format. It consists of the following methods","category":"page"},{"location":"lowlevel.html","page":"Low Level Interface","title":"Low Level Interface","text":"# general\nversion, uuid\n\n# study parameters\nstudyName, studyNumber, studyUuid, studyDescription\n\n# experiment parameters\nexperimentName, experimentNumber, experimentUuid, experimentDescription,\nexperimentSubject, experimentIsSimulation, experimentIsCalibration,\nexperimentHasMeasurement, experimentHasReconstruction\n\n# tracer parameters\ntracerName, tracerBatch, tracerVolume, tracerConcentration, tracerSolute,\ntracerInjectionTime, tracerVendor\n\n# scanner parameters\nscannerFacility, scannerOperator, scannerManufacturer, scannerName, scannerTopology\n\n# acquisition parameters\nacqStartTime, acqNumFrames, acqNumAverages, acqGradient, acqOffsetField,\nacqNumPeriodsPerFrame, acqSize\n\n# drive-field parameters\ndfNumChannels, dfStrength, dfPhase, dfBaseFrequency, dfCustomWaveform, dfDivider,\ndfWaveform, dfCycle\n\n# receiver parameters\nrxNumChannels, rxBandwidth, rxNumSamplingPoints, rxTransferFunction, rxUnit,\nrxDataConversionFactor, rxInductionFactor\n\n# measurements\nmeasData, measDataTDPeriods, measIsFourierTransformed, measIsTFCorrected,\nmeasIsBGCorrected, measIsFastFrameAxis, measIsFramePermutation, measIsFrequencySelection,\nmeasIsBGFrame, measIsSpectralLeakageCorrected, measFramePermutation\n\n# calibrations\ncalibSNR, calibFov, calibFovCenter, calibSize, calibOrder, calibPositions,\ncalibOffsetField, calibDeltaSampleSize, calibMethod, calibIsMeanderingGrid\n\n# reconstruction results\nrecoData, recoFov, recoFovCenter, recoSize, recoOrder, recoPositions\n\n# additional functions that should be implemented by an MPIFile\nfilepath, systemMatrixWithBG, systemMatrix, selectedChannels","category":"page"},{"location":"lowlevel.html","page":"Low Level Interface","title":"Low Level Interface","text":"The interface is structured in a similar way as the parameters within the MDF. Basically, there is a direct mapping between the MDF parameters and the MPIFiles interface. For instance the parameter acqNumAvarages maps to the MDF parameter /acquisition/numAverages. Also the dimensionality of the parameters described in the MDF is preserved. Thus, the MDF specification can be used as a documentation of the low level interface of MPIFiles.","category":"page"},{"location":"lowlevel.html","page":"Low Level Interface","title":"Low Level Interface","text":"note: Note\nNote that the dimensions in the MDF documentation are flipped compared to the dimensions in Julia. This is because Julia stores the data in column major order, while HDF5 considers row major order","category":"page"},{"location":"index.html#MPIFiles.jl","page":"Home","title":"MPIFiles.jl","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"Magnetic Particle Imaging Files","category":"page"},{"location":"index.html#Introduction","page":"Home","title":"Introduction","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"MPIFiles.jl is a Julia package for handling files that are related to the tomographic imaging method magnetic particle imaging. It supports different file formats:","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"Brukerfiles, i.e. files stored using the preclinical MPI scanner from Bruker\nMagnetic Particle Imaging Data Format (MDF) files\nIMT files, i.e. files created at the Institute of Medical Engineering in Lübeck","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"For all of these formats there is full support for reading the files. Write support is currently only available for MDF files. All files can be converted to MDF files using this capability.","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"MPIFiles.jl provides a generic interface for different MPI files. In turn it is possible to write generic algorithms that work for all supported file formats.","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"MPI files can be divided into three different categories","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"Measurements\nSystem Matrices\nReconstruction Results","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"Each of these file types is supported and discussed in the referenced pages.","category":"page"},{"location":"index.html#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"Start julia and open the package mode by entering ]. Then enter","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"add MPIFiles","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"This will install the packages MPIFiles.jl and all its dependencies.","category":"page"},{"location":"index.html#License-/-Terms-of-Usage","page":"Home","title":"License / Terms of Usage","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"The source code of this project is licensed under the MIT license. This implies that you are free to use, share, and adapt it. However, please give appropriate credit by citing the project.","category":"page"},{"location":"index.html#Community-Guidelines","page":"Home","title":"Community Guidelines","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"If you have problems using the software, find bugs, or have feature requests please use the issue tracker to contact us. For general questions we prefer that you contact the current maintainer directly by email.","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"We welcome community contributions to MPIFiles.jl. Simply create a pull request with your proposed changes.","category":"page"},{"location":"index.html#Contributors","page":"Home","title":"Contributors","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"Tobias Knopp (maintainer)\nMartin Möddel\nPatryk Szwargulski\nFlorian Griese\nFranziska Werner\nNadine Gdaniec\nMarija Boberg","category":"page"},{"location":"gettingStarted.html#Getting-Started","page":"Getting Started","title":"Getting Started","text":"","category":"section"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"In order to get started with MPIFiles we first need some example datasets. These can be obtained by calling","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"download(\"https://media.tuhh.de/ibi/mdfv2/measurement_V2.mdf\", \"measurements.mdf\")\ndownload(\"https://media.tuhh.de/ibi/mdfv2/systemMatrix_V2.mdf\", \"systemMatrix.mdf\")","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"which will download an MPI system matrix and an MPI measurement dataset into the current directory.","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"An MPI data file consists of a collection of parameters that can be divided into metadata and measurement data. We can open the downloaded MPI measurement data by calling","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"f = MPIFile(\"measurements.mdf\")","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"f can be considered to be a handle to the file. The file will be automatically  closed when f is garbage collected. The philosophy of MPIFiles.jl is that the content of the file is only loaded on demand. Hence, opening an MPI file is a cheap operation. This design allows it, to handle system matrices, which are larger than the main memory of the computer.","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"Using the file handle it is possible now to read out different metadata. For instance, we can determine the number of frames measured:","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"println( acqNumFrames(f) )\n500","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"Or we can access the drive field strength","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"println( dfStrength(f) )\n1×3×1 Array{Float64,3}:\n[:, :, 1] =\n 0.014  0.014  0.0","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"Now let us load some measurement data. This can be done by calling","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"u = getMeasurementsFD(f, frames=1:100, numAverages=100)","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"Then we can display the data using the PyPlot package","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"using PyPlot\nfigure(6, figsize=(6,4))\nsemilogy(abs.(u[1:400,1,1,1]))","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"(Image: Spectrum)","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"This shows a typical spectrum for a 2D Lissajous sampling pattern. The getMeasurementsFD is a high level interface for loading MPI data, which has several parameters that allow to customize the loading process. Details on loading measurement data are outlined in Measurements.","category":"page"},{"location":"gettingStarted.html","page":"Getting Started","title":"Getting Started","text":"In the following we will first discuss the low level interface.","category":"page"},{"location":"measurements.html#Measurements","page":"Measurements","title":"Measurements","text":"","category":"section"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"The low level interface allows to load measured MPI data via the measData function. The returned data is exactly how it is stored on disc. This has the disadvantage that the user needs to handle different sorts of data that can be stored in the measData field. To cope with this issue, the MDF also has a high level interface for loading measurement data. The first is the function","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"function getMeasurements(f::MPIFile, neglectBGFrames=true;\n                frames=neglectBGFrames ? (1:acqNumFGFrames(f)) : (1:acqNumFrames(f)),\n                numAverages=1,\n                bgCorrection=false,\n                interpolateBG=false,\n                tfCorrection=measIsTFCorrected(f),\n                sortFrames=false,\n                spectralLeakageCorrection=true,\n                kargs...)","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"that loads the MPI data in time domain. Background frames can be neglected or included, frames can be selected by specifying frames, block averaging can be applied by specifying numAverages, bgCorrection allows to apply background correction, tfCorrection allows for a correction of the transfer function, interpolateBG applies an optional interpolation in case that multiple background intervals are included in the measurement, sortFrames puts all background frames to the end of the returned data file, and spectralLeakageCorrection controls whether a spectral leakage correction is applied.","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"The array returned by getMeasurements is of type Float32 and has four dimensions","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"time dimension (over one period)\nreceive channel dimension\npatch dimension\nframe dimension","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"Instead of loading the data in time domain, one can also load the frequency domain data by calling","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"function getMeasurementsFD(f::MPIFile, neglectBGFrames=true;\n                  loadasreal=false,\n                  transposed=false,\n                  frequencies=nothing,\n                  tfCorrection=measIsTFCorrected(f),\n                  kargs...)","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"The function has basically the same parameters as getMeasurements but, additionally, it is possible to load the data in real form (useful when using a solver that cannot handle complex numbers), it is possible to specify the frequencies (specified by the indices) that should be loaded, and it is possible to transpose the data in a special way, where the frame dimension is changed to be the first dimension. getMeasurementsFD returns a 4D array where of type ComplexF32 with dimensions","category":"page"},{"location":"measurements.html","page":"Measurements","title":"Measurements","text":"frequency dimension\nreceive channel dimension\npatch dimension\nframe dimension","category":"page"}]
}
