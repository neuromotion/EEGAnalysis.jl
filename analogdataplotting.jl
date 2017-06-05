using DSP, PyPlot, OpenEphysLoader

#function to plot and display spectrogram of data x over time t with sampling rate fs
function plot_data(x::Array{Float64,1}, t::Array{Float64,1}, fs::Int64, title::String)
  fig = figure("$title")
  subplot(211) #subplot with one column and two rows, putting this plot in first row
  suptitle("$title")
  subplots_adjust(hspace=0.5)
  xlabel("Time (s)")
  ylabel("Frequency (Hz)")
  s = spectrogram(x)
  #ti = time(s)
  f = freq(s)
  imshow(flipdim(log10(power(s)),1), extent=[first(t), last(t),
          fs*first(f), fs*last(f)], aspect="auto") #display the spectrogram
  subplot(212) #put the spectrogram in the second row
  xlabel("Time (s)")
  ylabel("Amplitude (uV)")
  plot(t,x)
  end

type AnalogData
    x_all::Array{Float64,2} #data, with each row being a different channel and each column a time value
    t::Vector{Float64} #time
    original_fs::Int64
    fs::Int64
    channel_nums::Vector{Int64} #desired channel numbers
  end

  #plot and display spectrogram for an analogdata object given the desired channel
  function plot_analogdata(analogdata::AnalogData, channel::Int64, title::String)
    xall = analogdata.x_all
    x = xall[channel, :]
    ti = analogdata.t
    plot_data(x, ti, analogdata.fs, title)
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
