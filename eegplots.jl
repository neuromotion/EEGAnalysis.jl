using PyPlot, DSP
include("eegtypes.jl")

"""
    plot_spectrogram(axes, spect::Spectrogram, channel_num::Int64,
    plot_title::String="")
Display spectrogram of a chosen channel of a Spectrogram Object
"""
function plot_spectrogram(axes, spect::Spectrogram, channel_num::Int64,
  plot_title::String="")
  p = spect.power_all[channel_num]
  t = spect.time_bins
  t_first = spect.time[Int(first(t))]
  t_last = spect.time[Int(last(t))]
  f = spect.freq_bins
  fs = spect.analog_data.fs
  img = axes[:imshow](flipdim(p,1), extent=[t_first, t_last,
  fs*first(f), fs*last(f)], aspect="auto")
  xlabel("Time (s)")
  ylabel("Frequency (Hz)")
  colorbar(img)
  if plot_title == ""
    title("Channel $(spect.analog_data.channel_nums[channel_num])")
  else
    title(plot_title)
  end
end

"""
    plot_spectrogram(axes, session::Session, channel_num::Int64, plot_title::String="")
Plot the spectrogram of a chosen channel of the spectrogram of a session object.
"""
function plot_spectrogram(axes, session::Session, channel_num::Int64, plot_title::String="")
  if !isnull(session.spectrum)
    plot_title = "Channel $(get(session.eeg_data).channel_nums[channel_num]): $(session.name)"
    plot_spectrogram(axes, get(session.spectrum), channel_num, plot_title)
  else
    error("plot_spectrogram: no spectrogram in given session")
  end
end


"""
    plot_time(axes, eeg_data::AnalogData, channel_num::Int64,
    plot_title::String="")
Plot a channel of an analog data object vs time
"""
function plot_time(axes, eeg_data::AnalogData, channel_num::Int64,
  plot_title::String="")
  xall = eeg_data.x_all
  x = xall[channel_num, :]
  ti = eeg_data.t
  axes[:plot](ti,x)
  title(plot_title)
  xlabel("Time (s)")
end

"""
    plot_time(axes, session::Session, channel_num::Int64, plot_title::String="")
Plot a channel of an analog data object of a session object vs time.
"""
function plot_time(axes, session::Session, channel_num::Int64, plot_title::String="")
  if !isnull(session.eeg_data)
    plot_title = "Channel $(get(session.eeg_data).channel_nums[channel_num]): $(session.name)"
    plot_time(axes, get(session.eeg_data), channel_num, plot_title)
  else
    error("plot_time: no eeg_data in given session")
  end
end
