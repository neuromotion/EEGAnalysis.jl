using PyPlot, DSP

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
  colorbar(img)
  title(plot_title)
end

"""
    plot_time(axes, eeg_data::AnalogData, channel_num::Int64,
    plot_title::String="")
Plot a channel of an anlog data object vs time
"""
function plot_time(axes, eeg_data::AnalogData, channel_num::Int64,
  plot_title::String="")
  xall = eeg_data.x_all
  x = xall[channel_num, :]
  ti = eeg_data.t
  axes[:plot](ti,x)
  title(plot_title)
end
