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
end
