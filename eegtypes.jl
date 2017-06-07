using OpenEphysLoader, DSP, PyPlot

type AnalogData
    x_all::Array{Float64,2} #data, with each row being a different channel and each column a time value
    t::Vector{Float64} #time
    original_fs::Int64
    fs::Int64
    channel_nums::Vector{Int64} #desired channel numbers
  end

#create analogdata object with only data and time- assumes all channels are desired and that fs is 30,000
function AnalogData(x_all::Array{Float64,2}, t::Vector{Float64}; original_fs::Int64=30000, channel_nums::Vector{Int64}=[0,0])
    if channel_nums == nothing
      channel_nums = collect(1:size(x_all)[1])
    end
    fs = original_fs
    AD = AnalogData(x_all::Array{Float64,2}, t::Vector{Float64}, original_fs::Int64, fs::Int64, channel_nums::Vector{Int64})
end

#given a file path and sampling rate, returns an array of the data and an array of the time values
function load_continuous(path::String, fs::Int64)
  A = nothing
  open("$path", "r") do io
    A = Array(SampleArray(Float64, io))
      #sleep(0.1)
      seekstart(io)
      T = Array(TimeArray(Float64, io))
      return(A,T)
      end
end

#given the desired channel numbers, data directory, and data prefix, creates an analogdata object
#recording num is to account for if there are multiple recordings, in which case the appropriate number is added to the filename
function load_continuous_channels(prefix::String, data_directory::String, fs::Int64, channel_nums::Vector{Int64}, recording_num::Int64=1)
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
    filename = "/Users/mj2/data/eeg_tests/$data_directory/$prefix$chan_name$recording_num_str.continuous"
    (x,t) = load_continuous("$filename", fs)
    if isnull(x_all)
      x_all = x'
    else
      x_all = vcat(x_all, x')
    end
  end
  data = AnalogData(x_all, t; original_fs=fs, channel_nums=channel_nums)
  return data
end

type Session
  name::String
  fs_openephys::Int64
  directory::String
  eeg_data::Nullable{AnalogData}
  spectrum::Nullable{AnalogData}
  ica::Nullable{AnalogData}
  ica_spectrum::Nullable{AnalogData}
end

function Session(name::String, directory::String, eeg_data=Nullable{AnalogData}())
  S = Session(name, 30000, directory, eeg_data, Nullable{AnalogData}(), Nullable{AnalogData}(), Nullable{AnalogData}())
end

function load_eeg(session::Session, channel_nums::Vector{Int64})
  if !isnull(session.eeg_data)
    error("load_eeg: eeg_data already loaded")
  else
  session.eeg_data = load_continuous_channels("100_CH", session.directory, session.fs_openephys, channel_nums)
  end
end

#you can get the eeg_data in the form of a non-nullable analog data type by using get(session.eeg_data)

type Spectrogram
  analog_data::AnalogData
  power_all::Array{Float64,2}
  freq_bins::DSP.Util.Frequencies
  time_bins::FloatRange{Float64}
  time::Array{Float64,1}
end

function Spectrogram(analog_data::AnalogData)
  power_all = Array{Float64}[]
  freq_bins = DSP.Util.Frequencies
  time_bins = FloatRange{Float64}
  for chan_name = 1:(size(analog_data.channel_nums)[1])
    s = spectrogram(analog_data.x_all[chan_name, :])
    freq_bins = freq(s)
    time_bins = time(s)
    power_x = power(s) #should this be 1209601 by 15?
    push!(power_all, power_x)
  end
  ti = analog_data.t #is this the same as converting time bins back to time?
  S = Spectrogram(analog_data, power_all, freq_bins, time_bins, ti)
end