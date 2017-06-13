using PyPlot, DSP

"""
    normalize_data(x)
Normalize data
"""
function normalize_data(x)
  xnorm = x/maximum(x)
end

"""
    threshold_01(x, threshold)
Turn all values above a threshold into ones and all values below into zeros
"""
function threshold_01(x, threshold)
  hi_indices = x.>=threshold
  x_new = zeros(size(x))
  x_new[hi_indices] = 1
  return x_new
end

"""
    lowpass(data, cutoff, fs, order=5)
Lowpass filter data
"""
function lowpass(data, cutoff, fs, order=5)
  responsetype = Lowpass(cutoff, fs=fs)
    designmethod = Butterworth(order)
    filtered_data = filt(digitalfilter(responsetype, designmethod), data)
  end

"""
    highpass(data, cutoff, fs, order=5)
Highpass filter data
"""
  function highpass(data, cutoff, fs, order=5)
    responsetype = Highpass(cutoff, fs=fs)
      designmethod = Butterworth(order)
      filtered_data = filt(digitalfilter(responsetype, designmethod), data)
    end

"""
    downsample(x, ratio)
Downsample data, where ratio is ratio of input to output sample rate relationship.
Lowpass filter by at least as much as you are downsampling by.
"""
function downsample(x, ratio)
  filt(FIRFilter(x, ratio), x)
end

"""
    format_full_array(x::Array{Float64, 1})
Return string will full-precision respresentation of floats in the array.
For getting exact values in test cases.
"""
function format_full_array(x::Array{Float64, 1})
    string = "["
    for value in x
        # 30 decimal places should be more than enough
        string *= @sprintf("%0.30f, ", value)
    end
    string *= "]"
    return string
end
