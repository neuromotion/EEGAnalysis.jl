using PyPlot, DSP

#displays the spectrogram of a chosen channel of a Spectrogram object
function plot_spectrogram(axes, spect::Spectrogram, channel_num::Int64,
  plot_title::String="")
  p = spect.power_all[channel_num]
  println(minimum(p))
  #TODO instead of extent using t, use first & last time_bins and convert to sec
  t = spect.time
  f = spect.freq_bins
  fs = spect.analog_data.fs
  img = axes[:imshow](flipdim(p,1), extent=[first(t), last(t),
  fs*first(f), fs*last(f)], aspect="auto")
  colorbar(img)
  title(plot_title)
end

#plot a channel of an analog data object
function plot_time(axes, eeg_data::AnalogData, channel_num::Int64,
  plot_title::String="")
  xall = eeg_data.x_all
  x = xall[channel_num, :]
  ti = eeg_data.t
  axes[:plot](ti,x)
  title(plot_title)
end
