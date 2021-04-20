using Unitful

export MDFv2InMemoryPart, MDFv2Variables, MDFv2InMemoryPart, MDFv2Root, MDFv2Study,
       MDFv2Experiment, MDFv2Tracer, MDFv2Scanner, MDFv2Drivefield, MDFv2Receiver,
       MDFv2Acquisition, MDFv2Measurement, MDFv2Calibration, MDFv2Reconstruction, MDFv2InMemory

export defaultMDFv2Root, defaultMDFv2Study, defaultMDFv2Experiment,
       defaultMDFv2Tracer, defaultMDFv2Scanner, defaultMDFv2Drivefield,
       defaultMDFv2Receiver, defaultMDFv2Acquisition, defaultMDFv2Measurement,
       defaultMDFv2Calibration, defaultMDFv2Reconstruction, defaultMDFv2InMemory

export checkConsistency

abstract type MDFv2InMemoryPart end

mutable struct MDFv2Variables
  "tracer materials/injections for multi-color MPI"
  A::Union{Int64, Nothing}
  "acquired frames (N = O + E), same as a spatial position for calibration"
  N::Union{Int64, Nothing}
  "acquired background frames (E = N − O)"
  E::Union{Int64, Nothing}
  "acquired foreground frames (O = N − E)"
  O::Union{Int64, Nothing}
  "coefficients stored after sparsity transformation (B \\le O)"
  B::Union{Int64, Nothing}
  "periods within one frame"
  J::Union{Int64, Nothing}
  "partitions of each patch position"
  Y::Union{Int64, Nothing}
  "receive channels"
  C::Union{Int64, Nothing}
  "drive-field channels"
  D::Union{Int64, Nothing}
  "frequencies describing the drive-field waveform"
  F::Union{Int64, Nothing}
  "points sampled at receiver during one drive-field period"
  V::Union{Int64, Nothing}
  "sampling points containing processed data (W = V if no frequency selection or bandwidth reduction has been applied)"
  W::Union{Int64, Nothing}
  "frequencies describing the processed data (K = V/2 + 1 if no frequency selection or bandwidth reduction has been applied)"
  K::Union{Int64, Nothing}
  "frames in the reconstructed MPI data set"
  Q::Union{Int64, Nothing}
  "voxels in the reconstructed MPI data set"
  P::Union{Int64, Nothing}

  function MDFv2Variables()
    return new(nothing, nothing, nothing, nothing, nothing, nothing, nothing,
               nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing)
  end
end

"Root group of an in-memory MDF"
mutable struct MDFv2Root <: MDFv2InMemoryPart
  "UTC creation time of MDF data set"
  time::Union{DateTime, Missing}
  "Universally Unique Identifier (RFC 4122) of MDF file"
  uuid::Union{UUID, Missing}
  "Version of the file format"
  version::Union{VersionNumber, Missing}

  function MDFv2Root(;
    time = missing,
    uuid = missing,
    version = missing)
    
    return new(
      time,
      uuid,
      version
    )
  end
end

defaultMDFv2Root() = MDFv2Root(time=Dates.now(), uuid=UUIDs.uuid4(), version=VersionNumber("2.1.0"))

"Study group of an in-memory MDF"
mutable struct MDFv2Study <: MDFv2InMemoryPart
  "Short description of the study"
  description::Union{String, Missing}
  "Name of the study"
  name::Union{String, Missing}
  "Number of the study"
  number::Union{Int64, Missing}
  "UTC creation time of study; optional"
  time::Union{DateTime, Nothing}
  "Universally Unique Identifier (RFC 4122) of study"
  uuid::Union{UUID, Missing}

  function MDFv2Study(;
    description = missing,
    name = missing,
    number = missing,
    time = nothing,
    uuid = missing)
    
    return new(
      description,
      name,
      number,
      time,
      uuid
    )
  end
end

defaultMDFv2Study() = MDFv2Study()

"Experiment group of an in-memory MDF"
mutable struct MDFv2Experiment <: MDFv2InMemoryPart
  "Short description of the experiment"
  description::Union{String, Missing}
  "Flag indicating if the data in this file is simulated rather than measured"
  isSimulation::Union{Bool, Missing}
  "Experiment name"
  name::Union{String, Missing}
  "Experiment number within study"
  number::Union{Int64, Missing}
  "Name of the subject that was imaged"
  subject::Union{String, Missing}
  "Universally Unique Identifier (RFC 4122) of experiment"
  uuid::Union{UUID, Missing}

  function MDFv2Experiment(;
    description = missing,
    isSimulation = missing,
    name = missing,
    number = missing,
    subject = missing,
    uuid = missing)
    
    return new(
      description,
      isSimulation,
      name,
      number,
      subject,
      uuid
    )
  end
end

defaultMDFv2Experiment() = MDFv2Experiment() # Should we create the UUID automatically?

"Tracer group of an in-memory MDF; optional"
mutable struct MDFv2Tracer <: MDFv2InMemoryPart
  "Batch of tracer"
  batch::Union{Vector{String}, Missing}
  "A mol(solute)/L no Molar concentration of solute per litre"
  concentration::Union{Vector{Float64}, Missing}
  "UTC time at which tracer injection started; optional"
  injectionTime::Union{Vector{DateTime}, Nothing}
  "Name of tracer used in experiment"
  name::Union{Vector{String}, Missing}
  "Solute, e.g. Fe"
  solute::Union{Vector{String}, Missing}
  "Name of tracer supplier"
  vendor::Union{Vector{String}, Missing}
  "Total volume of applied tracer"
  volume::Union{Vector{Float64}, Missing}

  function MDFv2Tracer(;
    batch = missing,
    concentration = missing,
    injectionTime = nothing,
    name = missing,
    solute = missing,
    vendor = missing,
    volume = missing)
    
    return new(
      batch,
      concentration,
      injectionTime,
      name,
      solute,
      vendor,
      volume
    )
  end
end

defaultMDFv2Tracer() = MDFv2Tracer()

"Scanner group of an in-memory MDF"
mutable struct MDFv2Scanner <: MDFv2InMemoryPart
  "Diameter of the bore; optional"
  boreSize::Union{Float64, Nothing}
  "Facility where the MPI scanner is installed"
  facility::Union{String, Missing}
  "Scanner manufacturer"
  manufacturer::Union{String, Missing}
  "Scanner name"
  name::Union{String, Missing}
  "User who operates the MPI scanner"
  operator::Union{String, Missing}
  "Scanner topology (e.g. FFP, FFL, MPS)"
  topology::Union{String, Missing}

  function MDFv2Scanner(;
    boreSize = nothing,
    facility = missing,
    manufacturer = missing,
    name = missing,
    operator = missing,
    topology = missing)
    
    return new(
      boreSize,
      facility,
      manufacturer,
      name,
      operator,
      topology
    )
  end
end

defaultMDFv2Scanner() = MDFv2Scanner()

"Drivefield subgroup of acquisition group of an in-memory MDF"
mutable struct MDFv2Drivefield <: MDFv2InMemoryPart
  "Base frequency to derive drive field frequencies"
  baseFrequency::Union{Float64, Missing}
  "Trajectory cycle is determined by lcm(divider)/baseFrequency. It will not change
  when averaging was applied. The duration for measuring the V data points (i.e. the
  drive-field period) is given by the product of period and numAverages"
  cycle::Union{Float64, Missing}
  "Divider of the baseFrequency to determine the drive field frequencies"
  divider::Union{Array{Int64, 2}, Missing}
  "Number of drive field channels, denoted by D"
  numChannels::Union{Int64, Missing}
  "Applied drive field phase"
  phase::Union{Array{Float64, 3}, Missing}
  "Applied drive field strength"
  strength::Union{Array{Float64, 3}, Missing}
  "Waveform type: sine, triangle or custom"
  waveform::Union{Array{String, 2}, Missing}

  function MDFv2Drivefield(;
    baseFrequency = missing,
    cycle = missing,
    divider = missing,
    numChannels = missing,
    phase = missing,
    strength = missing,
    waveform = missing)
    
    return new(
      baseFrequency,
      cycle,
      divider,
      numChannels,
      phase,
      strength,
      waveform
    )
  end
end

defaultMDFv2Drivefield() = MDFv2Drivefield()

"Receiver subgroup of acquisition group of an in-memory MDF"
mutable struct MDFv2Receiver <: MDFv2InMemoryPart
  "Bandwidth of the receiver unit"
  bandwidth::Union{Float64, Missing}
  "Dimension less scaling factor and offset (a_c, b_c) to convert raw data into a
  physical quantity with corresponding unit of measurement unit; optional"
  dataConversionFactor::Union{Array{Float64, 2}, Nothing}
  "Induction factor mapping the projection of the magnetic moment to the voltage in the receive coil; optional"
  inductionFactor::Union{Array{Float64, 2}, Nothing}
  "Number of receive channels C"
  numChannels::Union{Int64, Missing}
  "Number of sampling points during one period, denoted by V"
  numSamplingPoints::Union{Int64, Missing}
  "Transfer function of the receive channels in Fourier domain. unit is the field
  from the /measurement group; optional"
  transferFunction::Union{Array{ComplexF64, 2}, Nothing}
  "SI unit of the measured quantity, usually Voltage V"
  unit::Union{String, Missing}

  function MDFv2Receiver(;
    bandwidth = missing,
    dataConversionFactor = missing,
    inductionFactor = missing,
    numChannels = missing,
    numSamplingPoints = missing,
    transferFunction = missing,
    unit = missing)
    
    return new(
      bandwidth,
      dataConversionFactor,
      inductionFactor,
      numChannels,
      numSamplingPoints,
      transferFunction,
      unit
    )
  end
end

defaultMDFv2Receiver() = MDFv2Receiver(unit = "V")

"Acquisition group of an in-memory MDF"
mutable struct MDFv2Acquisition <: MDFv2InMemoryPart
  "Gradient strength of the selection field in x, y, and z directions; optional"
  gradient::Union{Array{Float64, 4}, Nothing}
  "Number of block averages per drive-field period."
  numAverages::Union{Int64, Missing}
  "Number of available measurement frames"
  numFrames::Union{Int64, Missing}
  "Number of drive-field periods within a frame denoted by J"
  numPeriodsPerFrame::Union{Int64, Missing}
  "Offset field applied; optional"
  offsetField::Union{Array{Float64, 3}, Nothing}
  "UTC start time of MPI measurement"
  startTime::Union{DateTime, Missing}

  drivefield::Union{MDFv2Drivefield, Missing}
  receiver::Union{MDFv2Receiver, Missing}

  function MDFv2Acquisition(;
    gradient = nothing,
    numAverages = missing,
    numFrames = missing,
    numPeriodsPerFrame = missing,
    offsetField = nothing,
    startTime = missing,
    drivefield = missing,
    receiver = missing)
    
    return new(
      gradient,
      numAverages,
      numFrames,
      numPeriodsPerFrame,
      offsetField,
      startTime,
      drivefield,
      receiver
    )
  end
end

defaultMDFv2Acquisition() = MDFv2Acquisition()

"Measurement group of an in-memory MDF"
mutable struct MDFv2Measurement <: MDFv2InMemoryPart
  "Measured data at a specific processing stage"
  data::Union{Array{Number, 4}, Missing} # Should be mmapable
  "Indices of original frame order; optional if !isFramePermutation"
  framePermutation::Union{Vector{Int64}, Nothing}
  "Indices of selected frequency components; optional if !isFrequencySelection"
  frequencySelection::Union{Vector{Int64}, Nothing}
  "Flag, if the background has been subtracted"
  isBackgroundCorrected::Union{Bool, Missing}
  "Mask indicating for each of the N frames if it is a background measurement (true) or not"
  isBackgroundFrame::Union{Vector{Bool}, Missing}
  "Flag, if the frame dimension N has been moved to the last dimension"
  isFastFrameAxis::Union{Bool, Missing}
  "Flag, if the data is stored in frequency space"
  isFourierTransformed::Union{Bool, Missing}
  "Flag, if the order of frames has been changed, see framePermutation"
  isFramePermutation::Union{Bool, Missing}
  "Flag, if only a subset of frequencies has been selected and stored, see frequencySelection"
  isFrequencySelection::Union{Bool, Missing}
  "Flag, if the foreground frames are compressed along the frame dimension"
  isSparsityTransformed::Union{Bool, Missing}
  "Flag, if spectral leakage correction has been applied"
  isSpectralLeakageCorrected::Union{Bool, Missing}
  "Flag, if the data has been corrected by the transferFunction"
  isTransferFunctionCorrected::Union{Bool, Missing}
  "Name of the applied sparsity transformation; optional if !isSparsityTransformed"
  sparsityTransformation::Union{String, Nothing}
  "Subsampling indices \\beta{j,c,k,b}; optional if !isSparsityTransformed"
  subsamplingIndices::Union{Array{Integer, 4}, Nothing}

  function MDFv2Measurement(;
    data = missing,
    framePermutation = nothing,
    frequencySelection = nothing,
    isBackgroundCorrected = missing,
    isBackgroundFrame = missing,
    isFastFrameAxis = missing,
    isFourierTransformed = missing,
    isFramePermutation = missing,
    isFrequencySelection = missing,
    isSparsityTransformed = missing,
    isSpectralLeakageCorrected = missing,
    isTransferFunctionCorrected = missing,
    sparsityTransformation = nothing,
    subsamplingIndices = nothing)

    return new(
      data,
      framePermutation,
      frequencySelection,
      isBackgroundCorrected,
      isBackgroundFrame,
      isFastFrameAxis,
      isFourierTransformed,
      isFramePermutation,
      isFrequencySelection,
      isSparsityTransformed,
      isSpectralLeakageCorrected,
      isTransferFunctionCorrected,
      sparsityTransformation,
      subsamplingIndices
    )
  end
end

defaultMDFv2Measurement() = MDFv2Measurement()

"Calibration group of an in-memory MDF"
mutable struct MDFv2Calibration <: MDFv2InMemoryPart
  "Size of the delta sample used for calibration scan; optional"
  deltaSampleSize::Union{Vector{Float64}, Nothing}
  "Field of view of the system matrix; optional"
  fieldOfView::Union{Vector{Float64}, Nothing}
  "Center of the system matrix (relative to origin/center); optional"
  fieldOfViewCenter::Union{Vector{Float64}, Nothing}
  "Method used to obtain calibration data. Can for instance be robot, hybrid or simulation"
  method::Union{String, Missing}
  "Applied offset field strength to emulate a spatial position (x, y, z); optional"
  offsetFields::Union{Array{Float64, 2}, Nothing}
  "Ordering of the dimensions, default is xyz; optional"
  order::Union{String, Nothing}
  "Position of each of the grid points, stored as (x, y, z) triples; optional"
  positions::Union{Array{Float64, 2}, Nothing}
  "Number of voxels in each dimension, inner product is O; optional"
  size::Union{Vector{Float64}, Nothing}
  "Signal-to-noise estimate for recorded frequency components; optional"
  snr::Union{Array{Float64, 3}, Nothing}

  function MDFv2Calibration(;
    deltaSampleSize = nothing,
    fieldOfView = nothing,
    fieldOfViewCenter = nothing,
    method = missing,
    offsetFields = nothing,
    order = nothing,
    positions = nothing,
    size = nothing,
    snr = nothing)

    return new(
      deltaSampleSize,
      fieldOfView,
      fieldOfViewCenter,
      method,
      offsetFields,
      order,
      positions,
      size,
      snr
    )
  end
end

defaultMDFv2Calibration() = MDFv2Calibration(order="xyz")

"Reconstruction group of an in-memory MDF"
mutable struct MDFv2Reconstruction <: MDFv2InMemoryPart
  "Reconstructed data"
  data::Union{Array{Number, 3}, Missing}
  "Field of view of reconstructed data; optional"
  fieldOfView::Union{Vector{Float64}, Nothing}
  "Center of the reconstructed data (relative to scanner origin/center); optional"
  fieldOfViewCenter::Union{Vector{Float64}, Nothing}
  "Mask indicating for each of the P voxels if it is part of the overscan region (true) or not; optional"
  isOverscanRegion::Union{Vector{Bool}, Nothing}
  "Ordering of the dimensions, default is xyz; optional"
  order::Union{String, Nothing}
  "Position of each of the grid points, stored as (x, y, z) tripels; optional"
  positions::Union{Array{Float64, 2}, Nothing}
  "Number of voxels in each dimension, inner product is P; optional"
  size::Union{Vector{Int64}, Nothing}

  function MDFv2Reconstruction(;
    data = missing,
    fieldOfView = nothing,
    fieldOfViewCenter = nothing,
    isOverscanRegion = nothing,
    order = nothing,
    positions = nothing,
    size = nothing)

    return new(
      data,
      fieldOfView,
      fieldOfViewCenter,
      isOverscanRegion,
      order,
      positions,
      size
    )
  end
end

defaultMDFv2Reconstruction() = MDFv2Reconstruction(order="xyz")

mutable struct MDFv2InMemory <: MPIFile # TODO: Not sure, if MPIFile is a good fit
  root::Union{MDFv2Root, Missing}
  study::Union{MDFv2Study, Missing}
  experiment::Union{MDFv2Experiment, Missing}
  tracer::Union{MDFv2Tracer, Nothing}
  scanner::Union{MDFv2Scanner, Missing}
  acquisition::Union{MDFv2Acquisition, Missing}
  measurement::Union{MDFv2Measurement, Nothing}
  calibration::Union{MDFv2Calibration, Nothing}
  reconstruction::Union{MDFv2Reconstruction, Nothing}
  variables::MDFv2Variables

  function MDFv2InMemory(;
    root = missing,
    study = missing,
    experiment = missing,
    tracer = nothing,
    scanner = missing,
    acquisition = missing,
    measurement = nothing,
    calibration = nothing,
    reconstruction = nothing,
    variables = MDFv2Variables())

    return new(
      root,
      study,
      experiment,
      tracer,
      scanner,
      acquisition,
      measurement,
      calibration,
      reconstruction,
      variables
    )
  end
end

MDFv2InMemory(mdfFile::MDFFileV2) = inMemoryMDFFromMDFFileV2(mdfFile)
MDFv2InMemory(dict::Dict) = inMemoryMDFFromDict(dict)

function defaultMDFv2InMemory()
  return MDFv2InMemory(
    root = defaultMDFv2Root(),
    study = defaultMDFv2Study(),
    experiment = defaultMDFv2Experiment(),
    scanner = defaultMDFv2Scanner(),
    acquisition = defaultMDFv2Acquisition()
  )
end

function checkSizes(part::MDFv2Tracer, variables::MDFv2Variables)
  # Init comparison
  if isnothing(variables.A)
    variables.A = length(part.vendor)
  end

  # Check if all sizes match
  for fieldname in fieldnames(T)
    field = getproperty(part, fieldname)
    @assert length(field) == variables.A "Inconsistent dimensions in `$fieldname` in `$part`."
  end
end

function checkSizes(part::MDFv2Acquisition, variables::MDFv2Variables)
  # Check dimensions of `gradient` field
  if !isnothing(part.gradient)
    if isnothing(variables.J)
      variables.J = size(part.gradient, 1)
    else
      @assert variables.J == size(part.gradient, 1) "Inconsistent dimension J in `gradient` in `$part`."
    end

    if isnothing(variables.Y)
      variables.Y = size(part.gradient, 2)
    else
      @assert variables.Y = size(part.gradient, 1) "Inconsistent dimension Y in `gradient` in `$part`."
    end

    @assert size(part.gradient, 3) == 3 "Inconsistent third dimension in `gradient` in `$part`."
    @assert size(part.gradient, 4) == 3 "Inconsistent fourth dimension in `gradient` in `$part`."
  end

  # Check dimensions of `offsetField` field
  if !isnothing(part.offsetField)
    if isnothing(variables.J)
      variables.J = size(part.offsetField, 1)
    else
      @assert variables.J == size(part.offsetField, 1) "Inconsistent dimension J in `offsetField` in `$part`."
    end

    if isnothing(variables.Y)
      variables.Y = size(part.offsetField, 2)
    else
      @assert variables.Y == size(part.offsetField, 2) "Inconsistent dimension Y in `offsetField` in `$part`."
    end

    @assert size(part.offsetField, 3) == 3 "Inconsistent third dimension in `offsetField` in `$part`."
  end
end

function checkSizes(part::MDFv2Drivefield, variables::MDFv2Variables)
  # Pick variables first
  if isnothing(variables.D)
    variables.D = size(part.divider, 1)
  end
  if isnothing(variables.F)
    variables.F = size(part.divider, 2)
  end
  if isnothing(variables.J)
    variables.J = size(part.phase, 1)
  end

  # Then check dimensions for multidimensional fields
  @assert variables.D == size(part.divider, 1) "Inconsistent dimension D in `divider` in `$part`."
  @assert variables.F == size(part.divider, 2) "Inconsistent dimension F in `divider` in `$part`."

  @assert variables.J == size(part.phase, 1) "Inconsistent dimension J in `phase` in `$part`."
  @assert variables.D == size(part.phase, 2) "Inconsistent dimension D in `phase` in `$part`."
  @assert variables.F == size(part.phase, 3) "Inconsistent dimension F in `phase` in `$part`."

  @assert variables.J == size(part.strength, 1) "Inconsistent dimension J in `strength` in `$part`."
  @assert variables.D == size(part.strength, 2) "Inconsistent dimension D in `strength` in `$part`."
  @assert variables.F == size(part.strength, 3) "Inconsistent dimension F in `strength` in `$part`."

  @assert variables.D == size(part.waveform, 1) "Inconsistent dimension D in `waveform` in `$part`."
  @assert variables.F == size(part.waveform, 2) "Inconsistent dimension F in `waveform` in `$part`."
end

function checkSizes(part::MDFv2Receiver, variables::MDFv2Variables)
  # C is defined by numChannels
  if isnothing(variables.C)
    variables.C = numChannels
  end

  if !isnothing(part.dataConversionFactor)
    @assert variables.C == size(part.dataConversionFactor, 1) "Inconsistent dimension C in `dataConversionFactor` in `$part`."
    @assert size(part.dataConversionFactor, 2) == 2 "Inconsistent second dimension in `dataConversionFactor` in `$part`."
  end

  if !isnothing(part.inductionFactor)
    @assert variables.C == size(part.inductionFactor, 1) "Inconsistent dimension C in `inductionFactor` in `$part`."
  end

  if !isnothing(part.transferFunction)
    @assert variables.C == size(part.transferFunction, 1) "Inconsistent dimension C in `transferFunction` in `$part`."

    if isnothing(variables.K)
      variables.K = size(part.transferFunction, 2)
    else
      @assert variables.K == size(part.transferFunction, 2) "Inconsistent dimension K in `transferFunction` in `$part`."
    end
  end
end

function checkSizes(part::MDFv2Measurement, variables::MDFv2Variables)
  # TODO: check data consistency; I don't know how to to that since we can't know all variables
  # N × J × C × K or
  # J × C × K × N or
  # N × J × C × W or
  # J × C × W × N or
  # J×C×K×(B+E)

  if part.isFramePermutation
    if isnothing(variables.K)
      variables.N = length(part.framePermutation)
    else
      @assert variables.N == length(part.framePermutation) "Inconsistent dimension N in `framePermutation` in `$part`."
    end
  end

  if part.isFrequencySelection
    if isnothing(variables.K)
      variables.K = length(part.frequencySelection)
    else
      @assert variables.K == length(part.frequencySelection) "Inconsistent dimension K in `frequencySelection` in `$part`."
    end
  end

  @assert variables.N == length(part.isBackgroundFrame) "Inconsistent dimension N in `isBackgroundFrame` in `$part`."

  if part.isSparsityTransformed
    @assert !isnothing(part.sparsityTransformation) "Field `sparsityTransformation` must be set when `isSparsityTransformed` is set in in `$part`."
  end

  if part.isSparsityTransformed
    # J, C, K and B should be defined by now
    @assert variables.J == size(part.subsamplingIndices, 1) "Inconsistent dimension J in `subsamplingIndices` in `$part`."
    @assert variables.C == size(part.subsamplingIndices, 2) "Inconsistent dimension C in `subsamplingIndices` in `$part`."
    @assert variables.K == size(part.subsamplingIndices, 3) "Inconsistent dimension K in `subsamplingIndices` in `$part`."
    @assert variables.B == size(part.subsamplingIndices, 4) "Inconsistent dimension B in `subsamplingIndices` in `$part`."
  end
end

function checkSizes(part::MDFv2Calibration, variables::MDFv2Variables)
  if !isnothing(part.deltaSampleSize)
    @assert length(part.deltaSampleSize) == 3 "Inconsistent length in `deltaSampleSize` in `$part`."
  end

  if !isnothing(part.fieldOfView)
    @assert length(part.fieldOfView) == 3 "Inconsistent length in `fieldOfView` in `$part`."
  end

  if !isnothing(part.fieldOfViewCenter)
    @assert length(part.fieldOfViewCenter) == 3 "Inconsistent length in `fieldOfViewCenter` in `$part`."
  end

  if !isnothing(part.offsetFields)
    if isnothing(variables.O)
      variables.O = size(part.offsetFields, 1)
    else
      @assert variables.O == size(part.offsetFields, 2) "Inconsistent dimension O in `offsetFields` in `$part`."
    end
    @assert size(part.offsetFields, 2) == 3 "Inconsistent second dimension in `offsetFields` in `$part`."
  end

  if !isnothing(part.order)
    @assert part.order in ["xyz", "xzy", "yxz", "yzx", "zyx", "zxy"] "Wrong `order` of `$(part.order)` in `$part`."
  end

  if !isnothing(part.positions)
    # O must be defined by now
    @assert variables.O == size(part.positions, 1) "Inconsistent dimension O in `positions` in `$part`."
    @assert size(part.positions, 2) == 3 "Inconsistent second dimension in `positions` in `$part`."
  end

  if !isnothing(part.size)
    @assert length(part.size) == 3 "Inconsistent length in `size` in `$part`."
    # O must be defined by now
    @assert variables.O == prod(part.size) "The product of `size` with $(part.size) must equal O."
  end

  if !isnothing(part.snr)
    if isnothing(variables.J)
      variables.J = size(part.snr, 1)
    else
      @assert variables.J == size(part.snr, 1) "Inconsistent dimension J in `snr` in `$part`."
    end

    if isnothing(variables.C)
      variables.C = size(part.snr, 2)
    else
      @assert variables.C == size(part.snr, 2) "Inconsistent dimension C in `snr` in `$part`."
    end

    if isnothing(variables.K)
      variables.K = size(part.snr, 3)
    else
      @assert variables.K == size(part.snr, 3) "Inconsistent dimension K in `snr` in `$part`."
    end
  end
end

function checkSizes(part::MDFv2Reconstruction, variables::MDFv2Variables)
  # Pick variables first
  if isnothing(variables.Q)
    variables.Q = size(part.data, 1)
  end
  if isnothing(variables.P)
    variables.P = size(part.data, 2)
  end
  if isnothing(variables.S)
    variables.S = size(part.data, 1)
  end
  
  if !isnothing(part.fieldOfView)
    @assert length(part.fieldOfView) == 3 "Inconsistent length in `fieldOfView` in `$part`."
  end

  if !isnothing(part.fieldOfViewCenter)
    @assert length(part.fieldOfViewCenter) == 3 "Inconsistent length in `fieldOfViewCenter` in `$part`."
  end

  if !isnothing(part.isOverscanRegion)
    @assert variables.P == length(part.isOverscanRegion) "Inconsistent length in `isOverscanRegion` in `$part`."
  end

  if !isnothing(part.order)
    @assert part.order in ["xyz", "xzy", "yxz", "yzx", "zyx", "zxy"] "Wrong `order` of `$(part.order)` in `$part`."
  end

  if !isnothing(part.positions)
    @assert variables.P == size(part.positions, 1) "Inconsistent dimension P in `positions` in `$part`."
    @assert size(part.positions, 2) == 3 "Inconsistent second dimension in `positions` in `$part`."
  end

  if !isnothing(part.size)
    @assert length(part.size) == 3 "Inconsistent length in `size` in `$part`."
    # P must be defined by now
    @assert variables.P == prod(part.size) "The product of `size` with $(part.size) must equal O."
  end
end

"Check for missing fields in MDF parts"
function checkMissing(part::T) where T <: MDFv2InMemoryPart
  for (fieldname, fieldtype) in zip(fieldnames(T), fieldtypes(T))
    field = getproperty(part, fieldname)
    @assert ismissing(field) "The field `$fieldname` in `$part` is missing in the given MDF representation."
  end
end

"Check, whether all non-optional fields have been
set and if the dimensions of the fields match"
function checkConsistency(mdf::MDFv2InMemory)
  for (fieldname, fieldtype) in zip(fieldnames(MDFv2InMemory), fieldtypes(MDFv2InMemory))
    if fieldtype != MDFv2Variables
      field = getproperty(mdf, fieldname)
      @assert ismissing(field) "The field `$fieldname` is missing in the given MDF representation."
      
      checkMissing(field)
      checkSizes(field, mdf.variables)
    end
  end
end

# Create getters and setters
prefixes = Dict{String, String}(
  "MDFv2Root" => "",
  "MDFv2Study" => "study",
  "MDFv2Experiment" => "experiment",
  "MDFv2Tracer" => "tracer",
  "MDFv2Scanner" => "scanner",
  "MDFv2Acquisition" => "acq",
  "MDFv2Drivefield" => "df",
  "MDFv2Receiver" => "rx",
  "MDFv2Measurement" => "meas",
  "MDFv2Calibration" => "calib",
  "MDFv2Reconstruction" => "reco"
)
for (fieldname, fieldtype) in zip(fieldnames(MDFv2InMemory), fieldtypes(MDFv2InMemory))
  if fieldtype != MDFv2Variables
    # At the moment, this should be a Union
    fieldtype = (fieldtype.b <: MDFv2InMemoryPart) ? fieldtype.b : fieldtype.a

    for (partFieldname, partFieldtype) in zip(fieldnames(fieldtype), fieldtypes(fieldtype))
      partFieldnameStr = string(partFieldname)

      # The acquisition group has subgroups, so we need to go deeper there
      if !(partFieldnameStr == "drivefield" || partFieldnameStr == "receiver")
        if fieldtype != MDFv2Root
          capitalizedPartFieldname = uppercase(partFieldnameStr[1])*partFieldnameStr[2:end]
        else
          capitalizedPartFieldname = partFieldnameStr
        end
        functionSymbol = Symbol(prefixes[replace(string(fieldtype), "MPIFiles." => "")]*capitalizedPartFieldname)

        @eval begin
          # TODO: Add docstring from struct; I did not yet find a way to retrieve it
          function $(functionSymbol)(mdf::MDFv2InMemory)::$partFieldtype
            return mdf.$fieldname.$partFieldname
          end

          # TODO: Add docstring from struct; I did not yet find a way to retrieve it
          function $(functionSymbol)(mdf::MDFv2InMemory, value::$partFieldtype)
            # Automatically create optional fields if they do not exist
            if isnothing(mdf.$fieldname)
              mdf.$fieldname = $fieldtype()
            end
            mdf.$fieldname.$partFieldname = value
          end
        end
      else
        # At the moment, this should be a Union
        partFieldtype = (partFieldtype.b <: MDFv2InMemoryPart) ? partFieldtype.b : partFieldtype.a

        for (subPartFieldname, subPartFieldtype) in zip(fieldnames(partFieldtype), fieldtypes(partFieldtype))
          subPartFieldnameStr = string(subPartFieldname)
          capitalizedSubPartFieldname = uppercase(subPartFieldnameStr[1])*subPartFieldnameStr[2:end]
          functionSymbol = Symbol(prefixes[replace(string(partFieldtype), "MPIFiles." => "")]*capitalizedSubPartFieldname)
          @eval begin
            # TODO: Add docstring from struct; I did not yet find a way to retrieve it
            function $(functionSymbol)(mdf::MDFv2InMemory)::$subPartFieldtype
              return mdf.$fieldname.$partFieldname.$subPartFieldname
            end
  
            # TODO: Add docstring from struct; I did not yet find a way to retrieve it
            function $(functionSymbol)(mdf::MDFv2InMemory, value::$subPartFieldtype)
              # Automatically create optional fields if they do not exist
              if isnothing(mdf.$fieldname)
                mdf.$fieldname.$partFieldname = $partFieldtype()
              end
              mdf.$fieldname.$partFieldname.$subPartFieldname = value
            end
          end
        end
      end
    end
  end
end

# Some alias functions are needed
measIsTFCorrected(mdf::MDFv2InMemory) = measIsTransferFunctionCorrected(mdf)
measIsTFCorrected(mdf::MDFv2InMemory, value::Bool) = measIsTransferFunctionCorrected(mdf, value)

measIsBGCorrected(mdf::MDFv2InMemory) = measIsBackgroundCorrected(mdf)
measIsBGCorrected(mdf::MDFv2InMemory, value::Bool) = measIsBackgroundCorrected(mdf; value)

measIsBGFrame(mdf::MDFv2InMemory) = measIsBackgroundFrame(mdf)
measIsBGFrame(mdf::MDFv2InMemory, value::Vector{Bool}) = measIsBackgroundFrame(mdf, value)

calibSNR(mdf::MDFv2InMemory) = calibSnr(mdf)
calibSNR(mdf::MDFv2InMemory, value::Array{Float64, 3}) = calibSnr(mdf, value)

calibFov(mdf::MDFv2InMemory) = calibFieldOfView(mdf)
calibFov(mdf::MDFv2InMemory, value::Vector{Float64}) = calibFieldOfView(mdf, value)

calibFovCenter(mdf::MDFv2InMemory) = calibFieldOfViewCenter(mdf)
calibFovCenter(mdf::MDFv2InMemory, value::Vector{Float64}) = calibFieldOfViewCenter(mdf, value)

measIsCalibProcessed(mdf::MDFv2InMemory) = measIsFramePermutation(mdf) && 
                                           measIsFourierTransformed(mdf) &&
                                           measIsFastFrameAxis(mdf)

# And some utility functions
experimentHasReconstruction(mdf::MDFv2InMemory) = !isnothing(mdf.reconstruction)
experimentHasMeasurement(mdf::MDFv2InMemory) = !isnothing(mdf.measurement)

# Creation and conversion

"Create an in-memory MDF from a dict matching the respective function names."
function inMemoryMDFFromDict(dict::Dict)
  mdf = MDFv2InMemory()

  for (key, value) in dict
    # TODO: Will error on custom keys
    functionSymbol = Symbol(key)
    f = getfield(MPIFiles, functionSymbol)
    f(mdf, value)
  end

  return mdf
end

"Create a dict from an in-memory MDF by matching the respective function names."
function inMemoryMDFToDict(mdf::MDFv2InMemory)
  dict = Dict{String, Any}()

  for (fieldname, fieldtype) in zip(fieldnames(MDFv2InMemory), fieldtypes(MDFv2InMemory))
    if fieldtype != MDFv2Variables
      # At the moment, this should be a Union
      fieldtype = (fieldtype.b <: MDFv2InMemoryPart) ? fieldtype.b : fieldtype.a
  
      for (partFieldname, partFieldtype) in zip(fieldnames(fieldtype), fieldtypes(fieldtype))
        partFieldnameStr = string(partFieldname)
  
        # The acquisition group has subgroups, so we need to go deeper there
        if !(partFieldnameStr == "drivefield" || partFieldnameStr == "receiver")
          if fieldtype != MDFv2Root
            capitalizedPartFieldname = uppercase(partFieldnameStr[1])*partFieldnameStr[2:end]
          else
            capitalizedPartFieldname = partFieldnameStr
          end
  
          functionName = prefixes[replace(string(fieldtype), "MPIFiles." => "")]*capitalizedPartFieldname
          functionSymbol = Symbol(functionName)
          
          f = getfield(MPIFiles, functionSymbol)
          dict[functionName] = f(mdf)
        else
          for (subPartFieldname, subPartFieldtype) in zip(fieldnames(partFieldtype), fieldtypes(partFieldtype))
            # At the moment, this should be a Union
            partFieldtype = (partFieldtype.b <: MDFv2InMemoryPart) ? partFieldtype.b : partFieldtype.a
  
            subPartFieldnameStr = string(subPartFieldname)
            capitalizedSubPartFieldname = uppercase(subPartFieldnameStr[1])*subPartFieldnameStr[2:end]
            functionName = prefixes[replace(string(partFieldtype), "MPIFiles." => "")]*capitalizedSubPartFieldname
            functionSymbol = Symbol(functionName)
            
            f = getfield(MPIFiles, functionSymbol)
            dict[functionName] = f(mdf)
          end
        end
      end
    end
  end
end

"Create an in-memory MDF from an MDFFile."
function inMemoryMDFFromMDFFileV2(mdfFile::MDFFileV2)
  mdf = MDFv2InMemory()

  for (fieldname, fieldtype) in zip(fieldnames(MDFv2InMemory), fieldtypes(MDFv2InMemory))
    if fieldtype != MDFv2Variables
      # At the moment, this should be a Union
      fieldtype = (fieldtype.b <: MDFv2InMemoryPart) ? fieldtype.b : fieldtype.a
  
      for (partFieldname, partFieldtype) in zip(fieldnames(fieldtype), fieldtypes(fieldtype))
        partFieldnameStr = string(partFieldname)
  
        # The acquisition group has subgroups, so we need to go deeper there
        if !(partFieldnameStr == "drivefield" || partFieldnameStr == "receiver")
          if fieldtype != MDFv2Root
            capitalizedPartFieldname = uppercase(partFieldnameStr[1])*partFieldnameStr[2:end]
          else
            capitalizedPartFieldname = partFieldnameStr
          end
  
          functionName = prefixes[replace(string(fieldtype), "MPIFiles." => "")]*capitalizedPartFieldname
          functionSymbol = Symbol(functionName)
          
          f = getfield(MPIFiles, functionSymbol)
          f(mdf, f(mdfFile)) # Call the setter of an MDFv2InMemory with a getter from an MDFFileV2
        else
          for (subPartFieldname, subPartFieldtype) in zip(fieldnames(partFieldtype), fieldtypes(partFieldtype))
            # At the moment, this should be a Union
            partFieldtype = (partFieldtype.b <: MDFv2InMemoryPart) ? partFieldtype.b : partFieldtype.a
  
            subPartFieldnameStr = string(subPartFieldname)
            capitalizedSubPartFieldname = uppercase(subPartFieldnameStr[1])*subPartFieldnameStr[2:end]
            functionName = prefixes[replace(string(partFieldtype), "MPIFiles." => "")]*capitalizedSubPartFieldname
            functionSymbol = Symbol(functionName)
            
            f = getfield(MPIFiles, functionSymbol)
            f(mdf, f(mdfFile)) # Call the setter of an MDFv2InMemory with a getter from an MDFFileV2
          end
        end
      end
    end
  end

  return mdf
end

"Create an MDFFile from an in-memory MDF; alias to `saveasMDF`."
function inMemoryMDFToMDFFileV2(filename::String, mdf::MDFv2InMemory)
  saveasMDF(filename, mdf)
end

"Create an MDFFile from an in-memory MDF."
function saveasMDF(filename::String, mdf::MDFv2InMemory)
  dict = inMemoryMDFToDict(mdf)
  saveasMDF(filename, dict)
end


# This is non-standard; not yet supported
# dfCustomWaveform(f::MDFFileV2)::String = f["/acquisition/drivefield/customWaveform"]
# calibIsMeanderingGrid(f::MDFFile) = Bool(f["/calibration/isMeanderingGrid", 0])

# function rxTransferFunctionFileName(f::MDFFile)
#   parameter = "/acquisition/receiver/transferFunctionFileName"
#   if haskey(f.file, parameter)
#     return f[parameter]
#   else
#     return nothing
#   end
# end
# function rxHasTransferFunction(f::MDFFile)
#   haskey(f.file, "/acquisition/receiver/transferFunction")
# end

#TODO: I don't know what to do with these functions

# # measurements
# function measData(f::MDFFileV1, frames=1:acqNumFrames(f), periods=1:acqNumPeriodsPerFrame(f),
#                   receivers=1:rxNumChannels(f))
#   if !haskey(f.file, "/measurement")
#     # the V1 file is a calibration
#     data = f["/calibration/dataFD"]
#     if ndims(data) == 4
#       return reshape(reinterpret(Complex{eltype(data)}, vec(data)), (size(data,2),size(data,3),size(data,4),1))
#     else
#       return reshape(reinterpret(Complex{eltype(data)}, vec(data)), (size(data,2),size(data,3),size(data,4),size(data,5)))
#     end
#   end
#   tdExists = haskey(f.file, "/measurement/dataTD")

#   if tdExists
#     data = zeros(Float64, rxNumSamplingPoints(f), length(receivers), length(frames))
#     for (i,fr) in enumerate(frames)
#       data[:,:,:,i] = f.mmap_measData[:, receivers, fr]
#     end
#     return reshape(data,size(data,1),size(data,2),1,size(data,3))
#   else
#     data = zeros(Float64, 2, rxNumFrequencies(f), length(receivers), length(frames))
#     for (i,fr) in enumerate(frames)
#       data[:,:,:,i] = f.mmap_measData[:,:,receivers, fr]
#     end

#     dataFD = reshape(reinterpret(Complex{eltype(data)}, vec(data)), (size(data,2),size(data,3),size(data,4)))
#     dataTD = irfft(dataFD, 2*(size(data,2)-1), 1)
#     return reshape(dataTD,size(dataTD,1),size(dataTD,2),1,size(dataTD,3))
#   end
# end

# function measData(f::MDFFileV2, frames=1:acqNumFrames(f), periods=1:acqNumPeriodsPerFrame(f),
#                   receivers=1:rxNumChannels(f))

#   if measIsFastFrameAxis(f)
#     data = f.mmap_measData[frames, :, receivers, periods]
#     data = reshape(data, length(frames), size(f.mmap_measData,2), length(receivers), length(periods))
#   else
#     data = f.mmap_measData[:, receivers, periods, frames]
#     data = reshape(data, size(f.mmap_measData,1), length(receivers), length(periods), length(frames))
#   end
#   return data
# end


# function measDataTDPeriods(f::MDFFileV1, periods=1:acqNumPeriods(f),
#                   receivers=1:rxNumChannels(f))
#   tdExists = haskey(f.file, "/measurement/dataTD")

#   if tdExists
#     data = f.mmap_measData[:, receivers, periods]
#     return data
#   else
#     data = f.mmap_measData[:, :, receivers, periods]

#     dataFD = reshape(reinterpret(Complex{eltype(data)}, vec(data)), (size(data,2),size(data,3),size(data,4)))
#     dataTD = irfft(dataFD, 2*(size(data,2)-1), 1)
#     return dataTD
#   end
# end


# function measDataTDPeriods(f::MDFFileV2, periods=1:acqNumPeriods(f),
#                   receivers=1:rxNumChannels(f))
#   if measIsFastFrameAxis(f)
#     error("measDataTDPeriods can currently not handle transposed data!")
#   end

#   data = reshape(f.mmap_measData,Val(3))[:, receivers, periods]

#   return data
# end

# function systemMatrix(f::MDFFileV1, rows, bgCorrection=true)
#   if !experimentIsCalibration(f)
#     return nothing
#   end

#   data = reshape(f.mmap_measData,Val(3))[:, :, rows]
#   return reshape(reinterpret(Complex{eltype(data)}, vec(data)), (size(data,2),size(data,3)))
# end

# function systemMatrix(f::MDFFileV2, rows, bgCorrection=true)
#   if !haskey(f.file, "/measurement") || !measIsFastFrameAxis(f) ||
#     !measIsFourierTransformed(f)
#     return nothing
#   end

#   rows_ = rowsToSubsampledRows(f, rows)

#   data_ = reshape(f.mmap_measData, size(f.mmap_measData,1),
#                                     size(f.mmap_measData,2)*size(f.mmap_measData,3),
#                                     size(f.mmap_measData,4))[:, rows_, :]
#   data = reshape(data_, Val(2))

#   fgdata = data[measFGFrameIdx(f),:]

#   if measIsSparsityTransformed(f)
#     dataBackTrafo = similar(fgdata, prod(calibSize(f)), size(fgdata,2))
#     B = linearOperator(f["/measurement/sparsityTransformation"], calibSize(f))

#     tmp = f["/measurement/subsamplingIndices"]
#     subsamplingIndices_ = reshape(tmp, size(tmp,1),
#                                       size(tmp,2)*size(tmp,3),
#                                       size(tmp,4))[:, rows_, :]
#     subsamplingIndices = reshape(subsamplingIndices_, Val(2))

#     for l=1:size(fgdata,2)
#       dataBackTrafo[:,l] .= 0.0
#       dataBackTrafo[subsamplingIndices[:,l],l] .= fgdata[:,l]
#       dataBackTrafo[:,l] .= adjoint(B) * vec(dataBackTrafo[:,l])
#     end
#     fgdata = dataBackTrafo
#   end

#   if bgCorrection # this assumes equidistent bg frames
#     @debug "Applying bg correction on system matrix (MDF)"
#     bgdata = data[measBGFrameIdx(f),:]
#     blockLen = measBGFrameBlockLengths( invpermute!(measIsBGFrame(f), measFramePermutation(f)) )
#     st = 1
#     for j=1:length(blockLen)
#       bgdata[st:st+blockLen[j]-1,:] .=
#             mean(bgdata[st:st+blockLen[j]-1,:], dims=1)
#       st += blockLen[j]
#     end

#     bgdataInterp = interpolate(bgdata, (BSpline(Linear()), NoInterp()))
#     # Cubic does not work for complex numbers
#     origIndex = measFramePermutation(f)
#     M = size(fgdata,1)
#     K = size(bgdata,1)
#     N = M + K
#     for m=1:M
#       alpha = (origIndex[m]-1)/(N-1)*(K-1)+1
#       for k=1:size(fgdata,2)
#         fgdata[m,k] -= bgdataInterp(alpha,k)
#       end
#     end
#   end
#   return fgdata
# end

# function systemMatrixWithBG(f::MDFFileV2)
#   if !haskey(f.file, "/measurement") || !measIsFastFrameAxis(f) ||
#       !measIsFourierTransformed(f)
#       return nothing
#   end

#   data = f.mmap_measData[:, :, :, :]
#   return data
# end

# # This is a special variant used for matrix compression
# function systemMatrixWithBG(f::MDFFileV2, freq)
#   if !haskey(f.file, "/measurement") || !measIsFastFrameAxis(f) ||
#     !measIsFourierTransformed(f)
#     return nothing
#   end

#   data = f.mmap_measData[:, freq, :, :]
#   return data
# end

# # this is non-standard
# function recoParameters(f::MDFFile)
#   if !haskey(f.file, "/reconstruction/_parameters")
#     return nothing
#   else
#     return loadParams(f.file, "/reconstruction/_parameters")
#   end
# end

filepath(mdf::MDFv2InMemory) = nothing # Has to be implemented...