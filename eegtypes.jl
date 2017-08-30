using OpenEphysLoader, DSP, PyPlot

type AnalogData
    #data, with each row being a different channel and each column a time value
    x_all::Array{Float64,2}
    t::Vector{Float64} #time
    original_fs::Int64
    fs::Int64
    channel_nums::Vector{Int64} #desired channel numbers
end

"""
    AnalogData(x_all::Array{Float64,2},
               t::Vector{Float64};
               original_fs::Int64=30000,
               channel_nums::Vector{Int64}=[0,0])

Create analogdata object given only data and time- assumes all channels are
desired.
"""
# TODO fix docstring
function AnalogData(x_all::Array{Float64,2},
                    t::Vector{Float64};
                    original_fs::Int64=30000,
                    channel_nums::Vector{Int64}=[0,0])
    # TODO use nullable for default channel_nums?
    if channel_nums == [0,0]
        channel_nums = collect(1:size(x_all)[1])
    end
    fs = original_fs
    return AnalogData(
        x_all::Array{Float64,2},
        t::Vector{Float64},
        original_fs::Int64,
        fs::Int64,
        channel_nums::Vector{Int64}
    )
end

"""
    ad_equals(adone::AnaloglData, adtwo::AnalogData)

Check whether two analogdata objects are equal.
"""
function ad_equals(adone::AnalogData, adtwo::AnalogData)
    return (
        (adone.x_all == adtwo.x_all)
        && (adone.t == adtwo.t)
        && (adone.original_fs == adtwo.original_fs)
        && (adone.fs == adtwo.fs)
        && (adone.channel_nums == adtwo.channel_nums)
    )
end

# # TODO Why not use this, instead of ad_equals()?
# Base.==(x::AnalogData, y::AnalogData) =  (
#     (x.x_all == y.x_all)
#     && (x.t == y.t)
#     && (x.original_fs == y.original_fs)
#     && (x.fs == y.fs)
#     && (x.channel_nums == y.channel_nums)
# )

"""
    load_continuous(path::String, fs::Int64)

Return an array of the data and an array of the time values given a file path
and sampling rate
"""
# TODO docstring, openephysloader
function load_continuous(path::String, fs::Int64)
    expected_fs = 30_000
    if fs != expected_fs
        warn("Are you sure the openephys sample rate is $fs, not $expected_fs?")
    end

    A = nothing
    open("$path", "r") do io
        A = Array(SampleArray(Float64, io))
        #sleep(0.1)
        seekstart(io)
        T = Array(TimeArray(Float64, io))
        return(A,T)
    end
end

"""
    load_continuous_channels(prefix::String,
                             data_directory::String,fs::Int64,
                             channel_nums::Vector{Int64},
                             recording_num::Int64=1)

Creates an analogdata object given the desired channel numbers, data directory,
and data prefix. Recording num is to account for if there are multiple
recordings, in which case the appropriate number is added to the filename.
"""
# TODO review this
function load_continuous_channels(prefix::String,
                                  data_directory::String,
                                  fs::Int64,
                                  channel_nums::Vector{Int64},
                                  recording_num::Int64=1)
    x_all = Nullable{Array{Float64,2}}()
    t = nothing
    if recording_num==1
        recording_num_str = ""
    elseif recording_num>1
        recording_num_str = "_$recording_num"
    else
        error("load_continuous_channels: invalid recording number")
    end
    for chan_name in channel_nums
        file_name =
            "$data_directory/$prefix$chan_name$recording_num_str.continuous"
        (x,t) = load_continuous("$file_name", fs)
        if isnull(x_all)
            x_all = x'
        else
            x_all = vcat(x_all, x')
        end
    end

    # Explicit conversion fixes type problem when there's only one channel
    x_all = convert(Array, x_all)
    return AnalogData(x_all, t; original_fs=fs, channel_nums=channel_nums)
end

type DigitalData
    # Each row is a channel and each column is a time point
    x_all::Array{Bool,2}
    # Timestamps
    t::Vector{Float64}
    # Sample rate of the data when it was first loaded
    original_fs::Int64
    # Current sample rate, which may change because of downsampling etc.
    fs::Int64
    # TODO should this be channel_names instead? (as opposed to indices or nums)
    channel_nums::Vector{Int64} #desired channel numbers
end

"""
    DigitalData(x_all::Array{Bool,2},
                t::Vector{Float64};
                original_fs::Int64=30000,
                channel_nums::Vector{Int64}=[0,0])

Create digitaldata object given only data and time- assumes all channels are
desired.
"""
function DigitalData(x_all::Array{Bool,2},
                     t::Vector{Float64};
                     original_fs::Int64=30000,
                     channel_nums::Vector{Int64}=[0,0])
    # TODO use better default value - nullable?
    if channel_nums == [0,0]
        channel_nums = collect(1:size(x_all)[1])
    end
    fs = original_fs
    return DigitalData(
        x_all::Array{Bool,2},
        t::Vector{Float64},
        original_fs::Int64,
        fs::Int64,
        channel_nums::Vector{Int64}
    )
end

"""
    dd_equals(ddone::DigitalData, ddtwo::DigitalData)

Check whether two digitaldata objects are equal.
"""
function dd_equals(ddone::DigitalData, ddtwo::DigitalData)
    return (
        (ddone.x_all == ddtwo.x_all)
        && (ddone.t == ddtwo.t)
        && (ddone.original_fs == ddtwo.original_fs)
        && (ddone.fs == ddtwo.fs)
        && (ddone.channel_nums == ddtwo.channel_nums)
    )
end

type Spectrogram
    analog_data::AnalogData
    # TODO type?
    power_all
    freq_bins::DSP.Util.Frequencies
    time_bins::StepRangeLen{
        Float64,
        Base.TwicePrecision{Float64},
        Base.TwicePrecision{Float64}
    }
    time::Array{Float64,1}
    n::Int64
end

"""
    Spectrogram(analog_data::AnalogData, n=256)

Create a Spectrogram object from an AnalogData object. N decides the size of
time bins
"""
function Spectrogram(analog_data::AnalogData, n::Int64=256)
    power_all = Array{Float64}[]
    freq_bins = nothing
    time_bins = nothing
    for chan_name = 1:(size(analog_data.channel_nums)[1])
        s = spectrogram(analog_data.x_all[chan_name, :], n)
        freq_bins = freq(s)
        time_bins = time(s)
        #TODO think about clamp range below!
        power_x = 20.*log10(clamp!(power(s), .00001 , 100000000))
        push!(power_all, power_x)
    end
    ti = analog_data.t
    S = Spectrogram(analog_data, power_all, freq_bins, time_bins, ti, n)
end

type Session
    name::String
    fs_openephys::Int64
    directory::String
    eeg_data::Nullable{AnalogData}
    spectrum::Nullable{Spectrogram}
    ica::Nullable{AnalogData}
    ica_spectrum::Nullable{Spectrogram}
end

"""
    Session(name::String,
            directory::String,
            eeg_data=Nullable{AnalogData}(),
            n::Int64=256))

Create a Session object. Providing eeg_data will automatically create a
spectrogram, so change n here if necessary.
"""
function Session(name::String,
                 directory::String,
                 eeg_data=Nullable{AnalogData}(),
                 n::Int64=256)
    # TODO do nullable types need to be declared that way?
    # TODO test this after refactoring
    default_fs = 30_000

    spectrogram = nothing
    if isnull(eeg_data)
        spectrogram = Spectrogram(eeg_data, n)
    end

    S = Session(
        name,
        default_fs,
        directory,
        eeg_data,
        spectrogram,
        Nullable{AnalogData}(),
        Nullable{Spectrogram}()
    )
end

"""
    function session_equals(s1::Session, s2::Session)
Check whether two session objects are equal.
"""
function session_equals(s1::Session, s2::Session)
    return (
        (s1.name==s2.name)
        && (s1.fs_openephys==s2.fs_openephys)
        && (s1.directory==s2.directory)
        && ad_equals(get(s1.eeg_data), get(s2.eeg_data))
        && (get(s1.spectrum)==get(s2.spectrum))
        && ad_equals(get(s1.ica), get(s2.ica))
        && (get(s1.ica_spectrum)==get(s2.ica_spectrum))
    )
end

"""
    load_eeg(session::Session, channel_nums::Vector{Int64})
Load EEG data into a session
"""
function load_eeg(session::Session,
                  channel_nums::Vector{Int64},
                  prefix::String="100_CH")
    if !isnull(session.eeg_data)
        error("load_eeg: eeg_data already loaded")
    else
        session.eeg_data = load_continuous_channels(
            prefix,
            session.directory,
            session.fs_openephys,
            channel_nums
        )
        session.spectrum = Spectrogram(get(session.eeg_data))
    end
end

#you can get the eeg_data in the form of a non-nullable analog data type by
#using get(session.eeg_data)

"""
    lowpass_session(session::Session,
                    lowpass_cutoff::Float64,
                    lowpass_fs::Int64,
                    down_sample_factor::Int64,
                    lowpass_order::Int64=5,
                    prefix::String="100_CH")

Filter the eeg_data of a session with both lowpass and downsampling and return
the new filtered session. If no downsampling factor is provided, it is assumed
to be 1 and no downsampling occurs. Change n here if you want a different value
for the spectrogram of the filtered data.
"""
function lowpass_session(session::Session, lowpass_cutoff::Float64,
                         down_sample_factor::Int64=1, lowpass_order::Int64=5,
                         prefix::String="100_CH"; n::Int64=256)
    if isnull(session.eeg_data)
        error("lowpass_session: no eeg_data loaded")
    end

    new_eeg_data = down_sample(
        lowpass(get(session.eeg_data), lowpass_cutoff, lowpass_order),
        down_sample_factor
    )
    filt_session = Session(
        "Filtered $(session.name) (fL $(lowpass_cutoff) Hz, $(new_eeg_data.fs) fs)",
        session.directory,
        new_eeg_data,
        n
    )
    return filt_session
end

"""
    highpass_session(session::Session,
                     highpass_cutoff::Float64,
                     highpass_order::Int64=5,
                     prefix::String="100_CH";
                     n::Int64=256)

Highpass filter the eeg_data of a session and return the new filtered session.
Change n here if you want a different value for the spectrogram of the filtered
data.
"""
function highpass_session(session::Session,
                          highpass_cutoff::Float64,
                          highpass_order::Int64=5,
                          prefix::String="100_CH";
                          n::Int64=256)
    if isnull(session.eeg_data)
        error("highpass_session: no eeg_data loaded")
    end

    new_eeg_data = highpass(
        get(session.eeg_data),
        highpass_cutoff,
        get(session.eeg_data).fs,
        highpass_order
    )
    filt_session = Session(
        "Filtered $(session.name) (fH $(highpass_cutoff) Hz, $(new_eeg_data.fs) fs)",
        session.directory,
        new_eeg_data,
        n
    )
    return filt_session
end
