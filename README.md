# RadioPropagation
The following is implemented:
- Two-Ray propagation model.
- Rain attenuation for frequencies in the range 1-400 GHz.
- Fog attenuation for frequencies above 5 GHz.
- Atmospheric attenuation for frequencies up to 1000 GHz.

Add as submodule to your project by writing the following to a terminal in the project directory:
```
git submodule add https://github.com/ErikBuer/RadioPropagation.git
```

To update the submodules, write the following to a terminal in the project directory:
```
git submodule foreach git pull
```

To include the module in a Julia script, add the following to the file:
```julia
push!( LOAD_PATH, "./RadioPropagation/" )
using RadioPropagation
```

## Examples

### Two-Ray Propagation
Below is an example showing the two-way loss for two-ray propagation compared to that of free-space propagation.
The code for the eample can be found in the function documentation.
![Image](figures/example_figure.png?raw=true)

### Atmospheric attenuation
Atmospheric attenuation calculated as per [1].

```julia

```
![Image](figures/example_figure.png?raw=true)




[1] Rec. ITU-R P.676-12, Attenuation by atmospheric gases and related effects, ITU-R 2020.
