using PyPlot, DSP

"Normalize data"
function normalize(x)
  xnorm = x/maximum(x)
end

"Turn all values above a threshold into ones and all values below into zeros"
function threshold_01(x, threshold)
  hi_indices = x.>=threshold
  x_new = zeros(size(x))
  x_new[hi_indices] = 1
  return x_new
end

"Lowpass filter data"
function lowpass(data, cutoff, fs, order=5)
  responsetype = Lowpass(cutoff, fs=fs)
    designmethod = Butterworth(order)
    filtered_data = filt(digitalfilter(responsetype, designmethod), data)
  end

"Highpass filter data"
  function highpass(data, cutoff, fs, order=5)
    responsetype = Highpass(cutoff, fs=fs)
      designmethod = Butterworth(order)
      filtered_data = filt(digitalfilter(responsetype, designmethod), data)
    end

"Downsample data, where ratio is ratio of input to output sample rate relationship"
#lowpass filter by at least as much as you are downsampling
function downsample(x, ratio)
  filt(FIRFilter(x, ratio), x)
end

"Return string will full-precision respresentation of floats in the array"
function format_full_array(x::Array{Float64, 1})
    # For getting exact values for test cases.
    string = "["
    for value in x
        # 30 decimal places should be more than enough
        string *= @sprintf("%0.30f, ", value)
    end
    string *= "]"
    return string
end
