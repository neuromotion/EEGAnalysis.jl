using PyPlot, DSP

function normalize(x)
  xnorm = x/maximum(x)
end

function threshold_01(x, threshold)
  hi_indices = x.>=threshold
  x_new = zeros(size(x))
  x_new[hi_indices] = 1
  return x_new
end

function lowpass(data, cutoff, fs, order=5)
  responsetype = Lowpass(cutoff, fs=fs)
    designmethod = Butterworth(order)
    filtered_data = filt(digitalfilter(responsetype, designmethod), data)
  end

  function highpass(data, cutoff, fs, order=5)
    responsetype = Highpass(cutoff, fs=fs)
      designmethod = Butterworth(order)
      filtered_data = filt(digitalfilter(responsetype, designmethod), data)
    end

#ratio is ratio of input to output sample rate relationship
function downsample(x, ratio)
  filt(FIRFilter(x, ratio), x)
end


function format_full_array(x::Array{Float64, 1})
    # Return string with full-precision representations of floats in the array.
    # For getting exact values for test cases.
    string = "["
    for value in x
        # 30 decimal places should be more than enough
        string *= @sprintf("%0.30f, ", value)
    end
    string *= "]"
    return string
end
