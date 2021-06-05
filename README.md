# RadioPropagation
The following is implemented:
- Two-Ray propagation model.
- Rain attenuation for frequencies in the range 1-400 GHz.

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
