module RadioPropagation
	# using Plots
	using Printf

	c = 299792458; # m/s
	i = im;

	"""
	Calculate the two-way two-ray propagation between two points above a flat plane.
	Intended for radar propagation calculations.

	```julia
	two_ray_propagation()

	```

	- Radar Systems Engineering Lecture 5 Propagation through the Atmosphere, IEEE New Hampshire Section IEEE AES Society, 2010

	# Arguments
	- 'distance'            The distance parallel to the plane earth.
	- 'transmit_height'     The height of the transmitter above the plane earth.
	- 'receive_height'      The height of the receiver/target above the plane earth.
	- 'Γ'                           The reflection coefficient of the medium of the plane earth. -1 < Γ < 1.
	"""
	function two_ray_propagation( distance, transmit_height, receive_height, frequency_hz, Γ )
		λ = c/frequency_hz;
		Δϕ=  4*π*transmit_height*receive_height/(λ*distance);
		F = 1+abs(Γ)*exp(i*Δϕ);
		return F;
	end

	"""
	Empirical model for rain attenuation for frequencies between 1 and 400 GHz, linear polarization.
	Model uses closest freqyency in the underlying data.
	
	- M. A. Richards and J. A. Scheer and W. A. Holm, Principles of Modern Radar, SciTech Publishing, 2010.

	```julia
	rain_attenuation_db_per_km_circular_pol( 'v' , 30, 20 )
	3.3400000000000003
	```

	# Arguments
	- 'polarization'        The polarization, 'v', 'h'.
	- 'frequency_hz'     	The frequency of the propagating waves.
	- 'fall_rate_mm_hour'	The rain intensity [mm/h]. 
	"""
	function rain_attenuation_db_per_km( polarization::Char, frequency_ghz, fall_rate_mm_hour )
		r = fall_rate_mm_hour;
		
		# Empirical data:
		frequency_table_ghz = [1, 2, 3 ,6, 7, 8, 10, 12, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 120, 150, 200, 300, 400 ];
		ah = [ 3.87e-5, 1.54e-4, 6.5e-4, 1.75e-3, 3.01e-3, 4.54e-3, 1.01e-2, 1.88e-2, 3.67e-2, 7.51e-2, .124, .187, .263, .350, .442, .536, .707, .851, .975, 1.06, 1.12, 1.18, 1.31, 1.45, 1.36, 1.32 ];
		av = [ 3.52e-5, 1.38e-4, 5.91e-4, 1.55e-3, 2.65e-3, 3.95e-3, 8.87e-3, 1.68e-2, 3.47e-2, 6.91e-2, .113, .167, .233, .310, .393, .479, .642, .784, .906, .999, 1.06, 1.13, 1.27, 1.42, 1.35, 1.31 ];
		bh = [ .912, .963, 1.121, 1.308, 1.332, 1.327, 1.276, 1.217, 1.154, 1.099, 1.061, 1.021, .979, .939, .903, .873, .826, .793, .769, .753, .743, .731, .710, .689, .688, .683 ];
		bv = [ .88, .923, 1.075, 1.265, 1.312, 1.310, 1.264, 1.2, 1.128, 1.065, 1.030, 1.0, .963, .929, .897, .868, .824, .793, .769, .754, .744, .732, .711, .69, .689, .683 ];

		# TODO implement interpolation vor arbitrary frequency selection.
		index = argmin( abs.(  frequency_ghz.-frequency_table_ghz ) );
		if polarization == 'v'
			a = av[index];
			b = bv[index];
		else
			a = ah[index];
			b = bh[index];
		end

		α = a*r^b;
		return α;
   end

   """
	Empirical model for rain attenuation for frequencies between 1 and 400 GHz, circular polarization.
	Model uses closest freqyency in the underlying data.
	
	- M. A. Richards and J. A. Scheer and W. A. Holm, Principles of Modern Radar, SciTech Publishing, 2010.

	```julia
	rain_attenuation_db_per_km_circular_pol( 30, 20 )
	3.3400000000000003
	```

	# Arguments
	- 'frequency_hz'     	The frequency of the propagating waves.
	- 'fall_rate_mm_hour'	The rain intensity [mm/h]. 
	"""
	function rain_attenuation_db_per_km_circular_pol( frequency_ghz, fall_rate_mm_hour )
		α_lin( pol ) = rain_attenuation_db_per_km( pol, frequency_ghz, fall_rate_mm_hour );
		αv = α_lin('v');
		αh = α_lin('h');
		
		α = 1/sqrt(2) * sqrt(αv^2+αh^2);

		return α;
   end
end
