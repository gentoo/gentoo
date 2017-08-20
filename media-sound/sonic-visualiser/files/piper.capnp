
# Piper audio feature extraction: schema for low-level operation
#
# This file is formatted to 130 characters width, in order to fit the
# comments next to the schema definitions.
#
# Copyright (c) 2015-2017 Queen Mary, University of London, provided
# under a BSD-style licence. See the file COPYING for details.

@0xc4b1c6c44c999206;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("piper");

struct Basic {
    # Basic metadata common to many Piper structures.

    identifier         @0  :Text;                 # A computer-readable string. Must match the regex /^[a-zA-Z0-9_-]+$/.
    name               @1  :Text;                 # A short human-readable name or label. Must be present.
    description        @2  :Text;                 # An optional human-readable descriptive text that may accompany the name.
}

struct ParameterDescriptor {
    # Properties of an adjustable parameter. A parameter's value is just a single
    # float, but the descriptor explains how to interpret and present that value.
    # A Piper feature extractor has a static list of parameters. The properties of
    # a given parameter never change, in contrast to output descriptors, which
    # may have different properties depending on the configuration of the extractor.

    basic              @0  :Basic;                # Basic metadata about the parameter.
    unit               @1  :Text;                 # Human-recognisable unit of the parameter (e.g. Hz). May be left empty.
    minValue           @2  :Float32     = 0.0;    # Minimum value. Must be provided.
    maxValue           @3  :Float32     = 0.0;    # Maximum value. Must be provided.
    defaultValue       @4  :Float32     = 0.0;    # Default if the parameter is not set to anything else. Must be provided.
    isQuantized        @5  :Bool        = false;  # True if parameter values are quantized to a particular resolution.
    quantizeStep       @6  :Float32     = 0.0;    # Quantization resolution, if isQuantized.
    valueNames         @7  :List(Text)  = [];     # Optional human-readable labels for the values, if isQuantized.
}

enum SampleType {
    # How returned features are spaced on the input timeline.

    oneSamplePerStep   @0;                        # Each process input returns a feature aligned with that input's timestamp.
    fixedSampleRate    @1;                        # Features are equally spaced at a given sample rate.
    variableSampleRate @2;                        # Features have their own individual timestamps.
}

struct StaticOutputDescriptor {

    # Properties of an output, that is, a single stream of features
    # produced in response to process and finish requests. A feature
    # extractor may have any number of outputs, and it always
    # calculates and returns features from all of them when
    # processing; this is useful in cases where more than one feature
    # can be easily calculated using a single method.
    # 
    # This structure contains the properties of an output that are
    # static, i.e. that do not depend on the parameter values provided
    # at configuration, excluding the Basic struct parameters like id
    # and description.  The Basic struct properties are not included
    # for historical reasons: they were already referenced separately
    # in the OutputDescriptor and ExtractorStaticData before this
    # struct was introduced.
    
    typeURI            @0  :Text;                 # URI indicating the sort of feature that this output returns (see docs).
}

struct ConfiguredOutputDescriptor {
    # Properties of an output, that is, a single stream of features produced
    # in response to process and finish requests. A feature extractor may
    # have any number of outputs, and it always calculates and returns features
    # from all of them when processing; this is useful in cases where more
    # than one feature can be easily calculated using a single method.
    # This structure contains the properties of an output that are not static,
    # i.e. that may depend on the parameter values provided at configuration.

    unit               @0  :Text;                 # Human-recognisable unit of the bin values in output features. May be empty.
    hasFixedBinCount   @1  :Bool        = false;  # True if this output has an equal number of values in each returned feature.
    binCount           @2  :Int32       = 0;      # Number of values per feature for this output, if hasFixedBinCount.
    binNames           @3  :List(Text)  = [];     # Optional human-readable labels for the value bins, if hasFixedBinCount.
    hasKnownExtents    @4  :Bool        = false;  # True if all feature values fall within the same fixed min/max range.
    minValue           @5  :Float32     = 0.0;    # Minimum value in range for any value from this output, if hasKnownExtents.
    maxValue           @6  :Float32     = 0.0;    # Maximum value in range for any value from this output, if hasKnownExtents.
    isQuantized        @7  :Bool        = false;  # True if feature values are quantized to a particular resolution.
    quantizeStep       @8  :Float32     = 0.0;    # Quantization resolution, if isQuantized.
    sampleType         @9  :SampleType;           # How returned features from this output are spaced on the input timeline.
    sampleRate         @10 :Float32     = 0.0;    # Sample rate (features per second) if sampleType == fixedSampleRate.
    hasDuration        @11 :Bool        = false;  # True if features returned from this output will have a duration.
}

struct OutputDescriptor {
    # All the properties of an output, both static (the basic metadata and static
    # descriptor) and potentially dependent on configuration parameters (the
    # configured descriptor).

    basic              @0  :Basic;                # Basic metadata about the output.
    configured         @1  :ConfiguredOutputDescriptor;    # Properties of the output that may depend on configuration parameters.
    static             @2  :StaticOutputDescriptor;        # Properties (other than Basic) that do not depend on parameters.
}

enum InputDomain {
    # Whether a feature extractor requires time-domain audio input (i.e.
    # "normal" or "unprocessed" audio samples) or frequency-domain input
    # (i.e. resulting from windowed, usually overlapping, short-time
    # Fourier transforms).

    timeDomain         @0;                        # The plugin requires time-domain audio samples as input.
    frequencyDomain    @1;                        # The plugin requires input to have been pre-processed using windowed STFTs.
}

struct ExtractorStaticData {
    # Static properties of a feature extractor. That is, metadata about the
    # extractor that are the same regardless of how you configure or run it.

    key                @0  :Text;                 # String that "globally" identifies the extractor, used to load it (see docs).
    basic              @1  :Basic;                # Basic metadata about the extractor.
    maker              @2  :Text;                 # Human-readable text naming the author or vendor of the extractor.
    rights             @3  :Text;                 # Human-readable summary of copyright and/or licensing terms for the extractor.
    version            @4  :Int32;                # Version number of extractor; must increase if new algorithm changes results.
    category           @5  :List(Text);           # List of general->specific category labels for this extractor (see docs).
    minChannelCount    @6  :Int32;                # Minimum number of input channels of audio this extractor can accept.
    maxChannelCount    @7  :Int32;                # Maximum number of input channels of audio this extractor can accept.
    parameters         @8  :List(ParameterDescriptor);    # List of configurable parameter properties for the feature extractor.
    programs           @9  :List(Text);           # List of predefined programs. For backward-compatibility, not recommended.
    inputDomain        @10 :InputDomain;          # Whether the extractor requires time-domain or frequency-domain input audio.
    basicOutputInfo    @11 :List(Basic);          # Basic metadata about all of the outputs of the extractor.

    struct SOPair {
        # A mapping between output identifier and static descriptor for
	# that output.
	
        output         @0  :Text;                 # Output id, matching the output's descriptor's basic identifier.
        static         @1  :StaticOutputDescriptor;
    }

    staticOutputInfo   @12 :List(SOPair);         # Static descriptors for all outputs that have any static metadata.
}

struct RealTime {
    # Time structure. When used as a timestamp, this is relative to "start
    # of audio".
    
    sec                @0  :Int32       = 0;      # Number of seconds.
    nsec               @1  :Int32       = 0;      # Number of nanoseconds. Must have same sign as sec unless sec == 0.
}

struct ProcessInput {
    # Audio and timing input data provided to a process request.

    inputBuffers       @0  :List(List(Float32));  # A single block of audio data (time or frequency domain) for each channel.
    timestamp          @1  :RealTime;             # Time of start of block (time-domain) or "centre" of it (frequency-domain).
}

struct Feature {
    # A single feature calculated and returned from a process or finish request.

    hasTimestamp       @0  :Bool        = false;  # True if feature has a timestamp. Must be true for a variableSampleRate output.
    timestamp          @1  :RealTime;             # Timestamp of feature, if hasTimestamp.
    hasDuration        @2  :Bool        = false;  # True if feature has a duration. Must be true if output's hasDuration is true.
    duration           @3  :RealTime;             # Duration of feature, if hasDuration.
    label              @4  :Text;                 # Optional human-readable text attached to feature.
    featureValues      @5  :List(Float32) = [];   # The feature values themselves (of size binCount, if output hasFixedBinCount).
}

struct FeatureSet {
    # The set of all features, across all outputs, calculated and returned from
    # a single process or finish request.

    struct FSPair {
        # A mapping between output identifier and ordered list of features for
	# that output.
	
        output         @0  :Text;                 # Output id, matching the output's descriptor's basic identifier.
        features       @1  :List(Feature) = [];   # Features calculated for that output during the current request, in time order.
    }
    
    featurePairs       @0  :List(FSPair);         # The feature lists for all outputs for which any features have been calculated.
}

struct Framing {
    # Determines how audio should be split up into individual buffers for input.
    # If the feature extractor accepts frequency-domain input, then this
    # applies prior to the STFT transform.
    #
    # These values are sometimes mandatory, but in other contexts one or both may
    # be set to zero to mean "don't care". See documentation for structures that
    # include a framing field for details.
    
    blockSize          @0  :Int32;                # Number of time-domain audio samples per buffer (on each channel).
    stepSize           @1  :Int32;                # Number of samples to advance between buffers: equals blockSize for no overlap.
}

struct Configuration {
    # Bundle of parameter values and other configuration data for a feature-
    # extraction procedure.

    struct PVPair {
        # A mapping between parameter identifier and value.
	
        parameter      @0  :Text;                 # Parameter id, matching the parameter's descriptor's basic identifier.
        value          @1  :Float32;              # Value to set parameter to (within constraints given in parameter descriptor).
    }
    
    parameterValues    @0  :List(PVPair);         # Values for all parameters, or at least any that are to change from defaults.
    currentProgram     @1  :Text;                 # Selection of predefined program. For backward-compatibility, not recommended. 
    channelCount       @2  :Int32;                # Number of audio channels of input.
    framing            @3  :Framing;              # Step and block size for framing the input.
}

enum AdapterFlag {
    # Flags that may be used when requesting a server to load a feature
    # extractor, to ask the server to do some of the work of framing and input
    # conversion instead of leaving it to the client side. These affect the
    # apparent behaviour of the loaded extractor.

    adaptInputDomain   @0;                        # Input-domain conversion, so the extractor always expects time-domain input.
    adaptChannelCount  @1;                        # Channel mixing or duplication, so any number of input channels is acceptable. 
    adaptBufferSize    @2;                        # Framing, so the extractor accepts any blockSize of non-overlapping buffers.
}

const adaptAllSafe :List(AdapterFlag) =
    [ adaptInputDomain, adaptChannelCount ];
    # The set of adapter flags that can always be applied, leaving results unchanged.

const adaptAll :List(AdapterFlag) =
    [ adaptInputDomain, adaptChannelCount, adaptBufferSize ];
    # The set of adapter flags that may cause "equivalent" results to be returned (see documentation).

struct ListRequest {
    # Request a server to provide a list of available feature extractors.
    
    from               @0  :List(Text);           # If non-empty, provide only extractors found in the given list of "libraries".
}

struct ListResponse {
    # Response to a successful list request.
    
    available          @0  :List(ExtractorStaticData);    # List of static data about available feature extractors.
}

struct LoadRequest {
    # Request a server to load a feature extractor and return a handle to it.
    
    key                @0  :Text;                 # Key as found in the extractor's static data structure.
    inputSampleRate    @1  :Float32;              # Sample rate for input audio. Properties of the extractor may depend on this.
    adapterFlags       @2  :List(AdapterFlag);    # Set of optional flags to make any framing and input conversion requests.
}

struct LoadResponse {
    # Response to a successful load request.
    
    handle             @0  :Int32;                # Handle to be used to refer to the loaded feature extractor in future requests.
    staticData         @1  :ExtractorStaticData;  # Static data about this feature extractor, identical to that in list response.
    defaultConfiguration @2  :Configuration;      # Extractor's default parameter values and preferred input framing.
}

struct ConfigurationRequest {
    # Request a server to configure a loaded feature extractor and prepare
    # it for use. This request must be carried out on a feature extractor
    # before any process request can be made.
    
    handle             @0  :Int32;                # Handle as returned in the load response from the loading of this extractor.
    configuration      @1  :Configuration;        # Bundle of parameter values to set, and client's preferred input framing.
}

struct ConfigurationResponse {
    # Response to a successful configuration request.

    handle             @0  :Int32;                # Handle of extractor, as passed in the configuration request.
    outputs            @1  :List(OutputDescriptor);       # Full set of properties of all outputs following configuration.
    framing            @2  :Framing;              # Input framing that must be used for subsequent process requests.
}

struct ProcessRequest {
    # Request a server to process a buffer of audio using a loaded and
    # configured feature extractor.

    handle             @0  :Int32;                # Handle as returned in the load response from the loading of this extractor.
    processInput       @1  :ProcessInput;         # Audio in the input domain, with framing as in the configuration response.
}

struct ProcessResponse {
    # Response to a successful process request.

    handle             @0  :Int32;                # Handle of extractor, as passed in the process request.
    features           @1  :FeatureSet;           # All features across all outputs calculated during this process request.
}

struct FinishRequest {
    # Request a server to finish processing and unload a loaded feature
    # extractor. This request may be made at any time -- the extractor does
    # not have to have been configured or used. The extractor handle cannot
    # be used again with this server afterwards.

    handle             @0  :Int32;                # Handle as returned in the load response from the loading of this extractor.
}

struct FinishResponse {
    # Response to a successful finish request.

    handle             @0  :Int32;                # Handle of extractor, as passed in the finish request. May not be used again.
    features           @1  :FeatureSet;           # Features the extractor has calculated now that it knows all input has ended.
}

struct Error {
    # Response to any request that fails.

    code               @0  :Int32;                # Error code. 
    message            @1  :Text;                 # Error message.
}

struct RpcRequest {
    # Request bundle for use when using Cap'n Proto serialisation without
    # Cap'n Proto RPC layer. For Cap'n Proto RPC, see piper.rpc.capnp.

    id :union {
        # Identifier used solely to associate a response packet with its
	# originating request. Server does not examine the contents of this,
	# it just copies the request id structure into the response.
	
        number         @0  :Int32;
        tag            @1  :Text;
        none           @2  :Void;
    }
    
    request :union {
        # For more details, see the documentation for the individual
	# request structures.
	
	list           @3  :ListRequest;          # Provide a list of available feature extractors.
	load           @4  :LoadRequest;          # Load a feature extractor and return a handle to it.
	configure      @5  :ConfigurationRequest; # Configure a loaded feature extractor, set parameters, and prepare it for use.
	process        @6  :ProcessRequest;       # Process a single fixed-size buffer of audio and return calculated features.
	finish         @7  :FinishRequest;        # Get any remaining features and unload the extractor.
    }
}

struct RpcResponse {
    # Response bundle for use when using Cap'n Proto serialisation without
    # Cap'n Proto RPC layer. For Cap'n Proto RPC, see piper.rpc.capnp.

    id :union {
        # Identifier used solely to associate a response packet with its
	# originating request. Server does not examine the contents of this,
	# it just copies the request id structure into the response.
	
        number         @0  :Int32;
        tag            @1  :Text;
        none           @2  :Void;
    }

    response :union {
        # For more details, see the documentation for the individual
	# response structures.
	
        error          @3  :Error;                # The request (of whatever type) failed.
	list           @4  :ListResponse;         # List succeeded: here is static data about the requested extractors.
	load           @5  :LoadResponse;         # Load succeeded: here is a handle for the loaded extractor.
	configure      @6  :ConfigurationResponse;# Configure succeeded: ready to process, here are values such as block size.
	process        @7  :ProcessResponse;      # Process succeeded: here are all features calculated from this input block.
	finish         @8  :FinishResponse;       # Finish succeeded: extractor unloaded, here are all remaining features.
    }
}

