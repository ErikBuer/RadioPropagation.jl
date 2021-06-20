module RadioPropagation
	# using Plots
	using Printf

	c = 299792458; # m/s
	i = im;

	"""
	Calculate the two-way two-ray propagation between two points above a flat plane.
	Returns the propagation factor F. The one-way power propagation factor is |F|².

	- Radar Systems Engineering Lecture 5 Propagation through the Atmosphere, IEEE New Hampshire Section IEEE AES Society, 2010
	
	```julia
	# Example code plotting signal strength as function of range, compared to free space power spread
	using Plots

	c = 3e8;

	transmit_height_m	= 2;
	receive_height_m	= 10;
	target_range_m		= LinRange(20, 100, 10000);
	transmit_frequency_hz =3e9;
	λ = c/transmit_frequency_hz;
	Γ1 = -1;
	Γ2 = -0.6;

	F²( Γ ) = RadioPropagation.two_ray_propagation.( target_range_m, transmit_height_m, receive_height_m, transmit_frequency_hz, Γ );

	F²1 = F²( Γ1 );
	F²2 = F²( Γ2 );

	f⁴_db( F² ) = 10*log10.( abs2.( F² ));

	freespace_loss_db = 10 .*log10.(λ^2 ./( (4*π)^3 .*target_range_m .^4 ));
	bias = freespace_loss_db[1]


	plot1 = plot( 	target_range_m, f⁴_db.(F²1)+freespace_loss_db .-bias,
			 	 	xlabel 	= "Range (one-way) [m]",
					ylabel 	= "Two-way loss [dB]",
					title  	= "Free-space versus two-ray propagation.",
					ylims 	= (-30, 6),
					label 	= "|F|⁴+L, Γ=-1",
					legend	= true,
					xaxis	=:log,
					dpi=300)
	plot!( 	target_range_m, f⁴_db.(F²2)+freespace_loss_db .-bias,
	 		label = "|F|⁴+L, Γ=-0.6",
	 		xaxis	=:log )
	plot!( 	target_range_m, freespace_loss_db .-bias,
	 		label = "L",
	 		xaxis	=:log )
	savefig("figures/example_figure")

	```

	# Arguments
	- 'distance'            The distance parallel to the plane earth.
	- 'transmit_height'     The height of the transmitter above the plane earth.
	- 'receive_height'      The height of the receiver/target above the plane earth.
	- 'Γ'                           The reflection coefficient of the medium of the plane earth.
	"""
	function two_ray_propagation( distance, transmit_height, receive_height, frequency_hz, Γ )
		λ = c/frequency_hz;
		Δϕ=  4*π*transmit_height*receive_height/(λ*distance);
		F = 1+abs(Γ)*exp(i*Δϕ);
		return F;
	end

	"""
	Empirical model for RF rain attenuation for frequencies between 1 and 400 GHz, linear polarization.
	Model uses the closest frequency in the underlying data.
	
	- M. A. Richards and J. A. Scheer and W. A. Holm, Principles of Modern Radar, SciTech Publishing, 2010.

	```julia
	rain_attenuation_db_per_km_circular_pol( 'v' , 30, 20 )
	3.3400000000000003
	```

	# Arguments
	- 'polarization'        The polarization, 'v', 'h'.
	- 'frequency_ghz'     	The frequency of the propagating waves.
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
	Model uses closest frequency in the underlying data.
	One-way attenuation in dB/km.
	
	- M. A. Richards and J. A. Scheer and W. A. Holm, Principles of Modern Radar, SciTech Publishing, 2010.

	```julia
	rain_attenuation_db_per_km_circular_pol( 30, 20 )
	3.6755027981960815
	```

	# Arguments
	- 'frequency_ghz'     	The frequency of the propagating waves.
	- 'fall_rate_mm_hour'	The rain intensity [mm/h]. 
	"""
	function rain_attenuation_db_per_km_circular_pol( frequency_ghz, fall_rate_mm_hour )
		α_lin( pol ) = rain_attenuation_db_per_km( pol, frequency_ghz, fall_rate_mm_hour );
		αv = α_lin('v');
		αh = α_lin('h');
		
		α = 1/sqrt(2) * sqrt(αv^2+αh^2);

		return α;
	end

	"""
	Empirical model for rain attenuation for frequencies above 5 GHz.
	One-way attenuation in dB/km.
		
	- M. A. Richards and J. A. Scheer and W. A. Holm, Principles of Modern Radar, SciTech Publishing, 2010.

	```julia
	fog_attenuation_db_per_km_circular_pol( 10, 0.8, 23 );
	4.68976
	```

	# Arguments
	- 'frequency_ghz'	The frequency of the propagating waves.
	- 'M'				The watewater concentration in g/m³.
	- 'T_deg'			The air temperature in degree Celsius.
	"""
	function fog_attenuation_db_per_km( frequency_ghz, M, T_deg )
		T = T_deg;
		f = frequency_ghz

		α= M*( -1.347 + 0.66*f+(11.152/f) - 0.022*T )
		return α;
	end

	"""
	Empirical model for amostpheric gaseous attenuation for frequencies in the range 1 - 1000 GHz.
	One-way attenuation in dB/km.
		
	- Rec. ITU-R P.676-12, Attenuation by atmospheric gases and related effects, ITU-R 2020.

	
	```julia
	
	```

	# Arguments
	- 'frequency_ghz'	The frequency of the propagating waves.
	- 'T_kelvin'		The absolute temperature in kelvin.
	"""
	function atmostpheric_attenuation_db_per_km( frequency_ghz, T_kelvin=288.15, waper_density_g_m³=7.5, dry_air_pressure_h_pa=1013.25 )
		f = frequency_ghz;
		T = T_kelvin;
		p = dry_air_pressure_h_pa;	# Dry air pressure [hPa].
		e = p*T/216.7;				# Water vapour partial pressure [hPa].
		θ = 300/T;

		# Spectroscopic data for oxygen attenuation.
		# 		  f0 			a1			a2		a3		a4 		a5 		a6
		tab1 = 	[ 50.474214		0.975 		9.651	6.690 	0.0		2.566 	6.850
				  50.987745		2.529 		8.653	7.170 	0.0		2.246 	6.800
				  51.503360		6.193 		7.709	7.640 	0.0		1.947 	6.729
				  52.021429		14.320 		6.819	8.110 	0.0		1.667 	6.640
				  52.542418		31.240 		5.983	8.580 	0.0		1.388 	6.526
				  53.066934		64.290 		5.201	9.060 	0.0		1.349 	6.206
				  53.595775		124.600 	4.474	9.550 	0.0		2.227 	5.085
				  54.130025		227.300 	3.800	9.960 	0.0		3.170 	3.750
				  54.671180		389.700 	3.182	10.370 	0.0		3.558 	2.654
				  55.221384		627.100 	2.618	10.890	0.0		2.560 	2.952
				  55.783815		945.300 	2.109	11.340	0.0		-1.172 	6.135
				  56.264774		543.400 	0.014	17.030	0.0		3.525 	-0.978
				  56.363399		1331.800 	1.654	11.890	0.0		-2.378	6.547
				  56.968211		1746.600 	1.255	12.230	0.0		-3.545	6.451
				  57.612486		2120.100 	0.910	12.620	0.0		-5.416	6.056
				  58.323877		2363.700 	0.621	12.950	0.0		-1.932	0.436
				  58.446588		1442.100	0.083	14.910	0.0		6.768 	-1.273
				  59.164204		2379.900 	0.387	13.530	0.0		-6.561 	2.309
				  59.590983		2090.700 	0.207	14.080	0.0		6.957 	-0.776
				  60.306056		2103.400 	0.207	14.150	0.0		-6.395 	0.699
				  60.434778		2438.000 	0.386	13.390	0.0		6.342 	-2.825
				  61.150562		2479.500 	0.621	12.920	0.0		1.014 	-0.584
				  61.800158		2275.900 	0.910	12.630	0.0		5.014 	-6.619
				  62.411220		1915.400 	1.255	12.170	0.0		3.029 	-6.759
				  62.486253		1503.000 	0.083	15.130	0.0		-4.499 	0.844
				  62.997984		1490.200 	1.654	11.740	0.0		1.856 	-6.675
				  63.568526		1078.000 	2.108	11.340	0.0		0.658 	-6.139
				  64.127775		728.700 	2.617	10.880	0.0		-3.036 	-2.895
				  64.678910		461.300 	3.181	10.380	0.0		-3.968 	-2.590
				  65.224078		274.000 	3.800	9.960   0.0		-3.528 	-3.680
				  65.764779		153.000 	4.473	9.550   0.0		-2.548 	-5.002
				  66.302096		80.400 		5.200	9.060   0.0		-1.660 	-6.091
				  66.836834		39.800 		5.982	8.580   0.0		-1.680	-6.393
				  67.369601		18.560 		6.818	8.110   0.0		-1.956 	-6.475
				  67.900868		8.172 		7.708	7.640   0.0		-2.216 	-6.545
				  68.431006		3.397 		8.652	7.170   0.0		-2.492	-6.600
				  68.960312		1.334 		9.650	6.690   0.0		-2.773 	-6.650
				  118.750334 	940.300		0.010	16.640	0.0		-0.439	0.079
				  368.498246	67.400		0.048	16.400	0.0		0.0		0.0
				  424.763020	637.700		0.044	16.400	0.0		0.0		0.0
				  487.249273	237.400		0.049	16.000	0.0		0.0		0.0
				  715.392902	98.100		0.145	16.000	0.0		0.0		0.0
				  773.839490	572.300		0.141	16.200	0.0		0.0		0.0
				  834.145546	183.100		0.145	14.700	0.0		0.0		0.0]

		f0a = @view tab1[:,1];
		a1  = @view tab1[:,2];
		a2  = @view tab1[:,3];
		a3  = @view tab1[:,4];
		a4  = @view tab1[:,5];
		a5  = @view tab1[:,6];
		a6  = @view tab1[:,7];
	
		# Spectroscopic data for water vapour attenuation.
		# 		 f0 		b1		b2		b3		b4 		b5 		b6
		tab2 = [ 22.235080 	.1079	2.144	26.38	.76		5.087	1.00
				 67.803960 	.0011	8.732	28.58	.69		4.930	.82
				 119.995940 .0007	8.353	29.48	.70		4.780	.79
				 183.310087 2.273	.668 	29.06	.77		5.022	.85
				 321.225630 .0470	6.179	24.04	.67		4.398	.54
				 325.152888 1.514	1.541	28.23	.64		4.893	.74
				 336.227764 .0010	9.825	26.93	.69		4.740	.61
				 380.197353 11.67	1.048	28.11	.54		5.063	.89
				 390.134508 .0045	7.347	21.52	.63		4.810	.55
				 437.346667 .0632	5.048	18.45	.60		4.230	.48
				 439.150807 .9098	3.595	20.07	.63		4.483	.52
				 443.018343 .1920	5.048	15.55	.60		5.083	.50
				 448.001085 10.41	1.405	25.64	.66		5.028	.67
				 470.888999 .3254	3.597	21.34	.66		4.506	.65
				 474.689092 1.260	2.379	23.20	.65		4.804	.64
				 488.490108 .2529	2.852	25.86	.69		5.201	.72
				 503.568532 .0372	6.731	16.12	.61		3.980	.43
				 504.482692 .0124	6.731	16.12	.61		4.010	.45
				 547.676440 .9785	.158	26.00	.70		4.500	1.00
				 552.020960 .1840	.158	26.00	.70		4.500	1.00
				 556.935985 497.0	.159	30.86	.69		4.552	1.00
				 620.700807 5.015	2.391	24.38	.71		4.856	.68
				 645.766085 .0067	8.633	18.00	.60		4.000	.50
				 658.005280 .2732	7.816	32.10	.69		4.140	1.00
				 752.033113 243.4	.396 	30.86	.68		4.352	.84
				 841.051732 .0134	8.177	15.90	.33		5.760	.45
				 859.965698 .1325	8.055	30.60	.68		4.090	.84
				 899.303175 .0547	7.914	29.85	.68		4.530	.90
				 902.611085 .0386	8.429	28.65	.70		5.100	.95
				 906.205957 .1836	5.110	24.08	.70		4.700	.53
				 916.171582 8.400	1.441	26.73	.70		5.150	.78
				 923.112692 .0079	10.293 	29.00	.70		5.000	.80
				 970.315022 9.009	1.919 	25.50	.64		4.940	.67
				 987.926764 134.6	.257 	29.85	.68		4.550	.90
				 1780.000000 17506. .952 	196.3	2.00 	24.15	5.00]

		f0b = @view tab2[:,1];
		b1  = @view tab2[:,2];
		b2  = @view tab2[:,3];
		b3  = @view tab2[:,4];
		b4  = @view tab2[:,5];
		b5  = @view tab2[:,6];
		b6  = @view tab2[:,7];


		S_o(i) = a1[i]*10^(-7)*θ^3*exp(a2[i] (1-θ));
		S_w(i) = b1[i]*10^(-1)*e*\theta^3.5*exp(b2[i] (1-θ));
		
		f_(i) =  # TODO
		Δf_o  = a3*10^(-4) *(p*θ^(0.8-a4) + 1.1*e*θ);
		Δf_o  = \sqrt( Δf_o^2 + 2.25*10^(-6) );

		Δf_w  = b3*10^(-4) *(p*θ^(b4) + b5*e*θ^b6);
		Δf_w  = 0.535*Δf_w + sqrt( 0.217*Δf_w^2 + (2.1316*10^(-12*f_(i)^2)/ θ) )

		function δ(f)
			
			return α;
		end

		
		# TODO handle Δf_o and Δf_w
		F(i) = f/f_(i) *( (Δf-δ(f_(i)-f))/((f_(i)-f)^2 + Δf^2 ) + (Δf-δ(f_(i)-f))/((f_(i)+f)^2 + Δf^2) );
		
		d = 5.6*10^-4 * (p+e)*θ^0.8;
		N_D_prime(f) = f*p*θ^2 * ( (6.14*10^-5/( d*(1+(f/d)^2) )) + ( (1.4*10^-12 *p*θ^1.5) / ( 1+1.9*10^5 f^1.5 ) ) );
		
		i = #TODO

		N_d_prime_oxygen(f) = sum(S_o(i)*F_o(i))+N_D_prime(f);
		N_d_prime_water_vapour(f) = S_w(i)*F_w(i);
		
		γ = 0.1820*f*(N_d_prime_oxygen(f)+N_d_prime_water_vapour(f));
		return γ;
	end
end
