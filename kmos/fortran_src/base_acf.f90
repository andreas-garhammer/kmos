!  This file was generated by kMOS (kMC modelling on steroids)
!  written by Max J. Hoffmann mjhoffmann@gmail.com (C) 2009-2013.
!  The model was written by Andreas Garhammer.

!  This file is part of kmos.
!
!  kmos is free software; you can redistribute it and/or modify
!  it under the terms of the GNU General Public License as published by
!  the Free Software Foundation; either version 2 of the License, or
!  (at your option) any later version.
!
!  kmos is distributed in the hope that it will be useful,
!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!  GNU General Public License for more details.
!
!  You should have received a copy of the GNU General Public License
!  along with kmos; if not, write to the Free Software
!  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
!  USA
!****h* kmos/base_acf
! FUNCTION
!    Implements the mappings between the real space lattice
!    and the 1-D lattice, which kmos/base operates on.
!    Furthermore replicates all geometry specific functions of kmos/base
!    in terms of lattice coordinates.
!    Using this module each site can be addressed with 4-tuple
!    ``(i, j, k, n)`` where ``i, j, k`` define the unit cell and
!    ``n`` the site within the unit cell.
!
!******


module base_acf
use kind_values
use base



!------ No implicit definition of variables !
implicit none

!!------ All variables, function and subroutine are private by default
!private
!
!
!
!! The following subroutines and functions are made public
!public :: deallocate_acf, &
!deallocate_property_acf, &
!get_property_acf, &
!get_id_arr, &
!get_trajectory, &
!assign_particle_id, &
!update_id_arr, &
!set_property_acf, &
!set_types, &
!set_product_property, &
!update_trajectory, &
!calc_nr_of_ions, &
!initialize_acf, &
!initialize_mean_squared_displacement, &
!get_nr_of_ions, &
!allocate_acf, &
!get_displacement, &
!update_displacement, &
!calc_mean_squared_disp, &
!allocate_config_bin_acf, &
!get_config_bin_acf, &
!calc_acf, &
!get_site_arr,&
!get_product_property, &
!get_types, &
!get_property_o, &
!get_buffer_acf, &
!update_property_and_buffer_acf, &
!update_config_bin, &
!update_buffer_acf, &
!get_counter_write_in_bin, &
!drain_process, &
!source_process, &
!update_after_wrap_acf, &
!allocate_trajectory, &
!update_nr_of_ions_before_kmc_step_acf







!------ A. Garhammer 2015------
integer(kind=iint), dimension(:), allocatable :: id_arr
!****v* base/id_arr
! FUNCTION
!   Stores id of the particle, which occupies the nr_of_sites.
!******
!------ A. Garhammer 2016------
integer(kind=iint), dimension(:), allocatable :: site_arr
!****v* base/site_arr
! FUNCTION
!   Stores site number, for every particle_id.
!******
!------ A. Garhammer 2016------
real(kind=rdouble), dimension(:,:), allocatable :: displacement
!****v* base/displacement
! FUNCTION
!   Stores the displacement for each particle.
!******
!------ A. Garhammer 2015------
integer(kind=iint), dimension(:), allocatable :: property_acf
!****v* base/property_acf
! FUNCTION
!   Stores the property of each site.
!******
!------ A. Garhammer 2015------
integer(kind=iint), dimension(:), allocatable :: property_o
!****v* base/property_o
! FUNCTION
!   Stores the property of each site.
!******
!------ A. Garhammer 2016------
real(kind=rdouble), dimension(:), allocatable :: types
!****v* base/types
! FUNCTION
!   Stores the trajectory (property for every kmc step) for each particle.
!******
!------ A. Garhammer 2016------
real(kind=rdouble), dimension(:, :), allocatable :: product_property
!****v* base/product_property
! FUNCTION
!   Stores the trajectory (property for every kmc step) for each particle.
!******
!------ A. Garhammer 2015------
integer(kind=iint), dimension(:, :), allocatable :: trajectory
!****v* base/trajectory
! FUNCTION
!   Stores the trajectory (property for every kmc step) for each particle.
!******
!------ A. Garhammer 2016------
real(kind = rdouble), dimension(:), allocatable :: buffer_acf
!****v* base/config_bin
! FUNCTION
!   Stores the property average over all particles and all wraps for every bin.
!******
!------ A. Garhammer 2016------
real(kind = rdouble), dimension(:), allocatable :: config_bin
!****v* base/config_bin
! FUNCTION
!   Stores the property average over all particles and all wraps for every bin.
!******
!------ A. Garhammer 2016------
real(kind = rdouble), dimension(:), allocatable :: counter_write_in_bin
!****v* base/config_bin
! FUNCTION
!   Stores the property average over all particles and all wraps for every bin.
!******
!------ A. Garhammer 2015------
integer(kind = iint) :: nr_of_ions
!****v* base/nr_of_ions
! FUNCTION
!   Stores the number of ions in the lattice.
!******
!------ A. Garhammer 2016------
integer(kind = iint) :: nr_of_ions_before_kmc_step_acf
!****v* base/nr_of_ions
! FUNCTION
!   Stores the number of ions in the lattice.
!******
!------ A. Garhammer 2016------
integer(kind = iint) :: bin_index
!****v* base/bin_index
! FUNCTION
!   Index of bin which is needed for the calculation of the ACF.
!******
!------ A. Garhammer 2016------
integer(kind = iint) :: nr_of_bins
!****v* base/nr_of_bins
! FUNCTION
!   Number of bins which is given by the user for the calculation of the ACF.
!******
!------ A. Garhammer 2016------
real(kind=rdouble) :: t_bin
!****v* base/t_bin
! FUNCTION
!   Bin size in s.
!******
!------ A. Garhammer 2016------
real(kind=rdouble) :: t_f
!****v* base/kmc_time
! FUNCTION
!   Decay time of the ACF in s, which is given by the user.
!******
!------ A. Garhammer 2016------
real(kind=rdouble) :: t_o
!****v* base/t_o
! FUNCTION
!  Sum of decay times in seconds.
!******
!------ A. Garhammer 2016------
integer(kind=iint) :: wrap_count
!****v* base/wrap_count
! FUNCTION
!  Number of wraps for the time average of every bin.
!******
!------ A. Garhammer 2015------
integer(kind=ilong) :: kmc_step_acf
!****v* base/kmc_step_acf
! FUNCTION
!   Number of kMC steps executed for the calculation of acf.
!******


!****************
contains
!****************

!------ A. Garhammer 2015------
subroutine calc_nr_of_ions(trace_species)
!****f* base/calc_nr_of_ions
! FUNCTION
!    Calculate the number of ions.
!
! ARGUMENTS
!
!    * ``trace_species`` positive integer number that represents the species which is traced.
!******
!---------------I/O variables---------------
integer(kind = iint) :: k, species, volume
integer(kind = iint), intent(in) :: trace_species

nr_of_ions = 0

call get_volume(volume)

do k = 1, volume
  species = get_species(k)
if( species == trace_species )then
nr_of_ions = nr_of_ions + 1
endif
enddo


end subroutine calc_nr_of_ions

subroutine update_nr_of_ions_before_kmc_step_acf()
!****f* base/calc_nr_of_ions
! FUNCTION
!    Calculate the number of ions.
!
! ARGUMENTS
!
!    * ``trace_species`` positive integer number that represents the species which is traced.
!******
!---------------I/O variables---------------

nr_of_ions_before_kmc_step_acf = nr_of_ions


end subroutine update_nr_of_ions_before_kmc_step_acf


!------ A. Garhammer 2015------
subroutine get_nr_of_ions(return_nr_of_ions)
!****f* base/get_nr_of_ions
! FUNCTION
!    Returns current number of ions of the trace_species as iint integer as defined in kind_values.f90.
!
! ARGUMENTS
!
!    * ``return_nr_of_ions`` writeable integer, where the nr_of_ions will be stored.
!******
!---------------I/O variables---------------
integer(kind=iint), intent(out) :: return_nr_of_ions


return_nr_of_ions = nr_of_ions

end subroutine get_nr_of_ions



!------ A. Garhammer 2015------
subroutine initialize_acf(trace_species)
!****f* base/initialize_acf
! FUNCTION
!    initialize_acf allocates and initializes the arrays for calculating the autocorrelation function (ACF).
!    The subroutine assigns each particle (trace_species) an id for the initial state and saves this id in id_arr.
!    Additionally, the trajectory array and the config array with corresponding properties are updated.
!    The user must specify the number of steps and the species to be used for calculating the ACF.
!    Furthermore, the user can decide whether the trajectory is to be recorded (traj_on = ``True``) during the calculation of the ACF or not (traj_on = ``False``).
!    The user have to call this subroutine, before the kmc run can start to calculate the ACF
!
! ARGUMENTS
!
!    * ``nr_of_steps`` writeable integer, where the number of kmc steps for the calculation of the acf will be stored.
!    * ``trace_species`` positive integer number that represents the species which is traced.
!    * ``traj_on`` writeable boolean, which turn on or off the recording of the trajectory.
!******
!---------------I/O variables---------------
integer(kind = iint) :: k, i, volume, species
integer(kind = iint), intent(in) :: trace_species

!Calculation of the number of ions
call calc_nr_of_ions(trace_species)
nr_of_ions_before_kmc_step_acf = nr_of_ions

!allocates the arrays for the autocorrelationfunction and initialize with 0
call get_volume(volume)


!Start initialization process for id_arr and trajectory
i = 1
do k = 1, volume
  species = get_species(k)
if( species == trace_species )then
id_arr(k) = i
site_arr(i) = k
i = i + 1
else
id_arr(k) = 0
endif
enddo

call update_property_and_buffer_acf()


end subroutine initialize_acf

!------ A. Garhammer 2016------
subroutine initialize_mean_squared_displacement(trace_species)
!****f* base/initialize_mean_squared_displacement
! FUNCTION
!    initialize_mean_squared_displacement allocates and initializes the arrays for calculating the mean squared displacement.
!    The subroutine assigns each particle (trace_species) an id for the initial state and saves this id in id_arr.
!    The user must specify the species to be used for calculating the mean squared displacement.
!    The user have to call this subroutine, before the kmc run can start to calculate the mean squared displacement.
!
! ARGUMENTS
!
!    * ``trace_species`` positive integer number that represents the species which is traced.
!
!
!******
!---------------I/O variables---------------
integer(kind = iint) :: k, i, volume, species
integer(kind = iint), intent(in) :: trace_species
!Calculation of the number of ions
call calc_nr_of_ions(trace_species)
call get_volume(volume)



allocate(id_arr(0:volume))
id_arr = 0

allocate(site_arr(0:volume))
site_arr = 0



allocate(displacement(nr_of_ions, 3))
displacement = 0



!Start initialization process for id_arr
i = 1
do k = 1, volume
   species = get_species(k)
if( species == trace_species )then
id_arr(k) = i
site_arr(i) = k
i = i + 1
else
id_arr(k) = 0
endif
enddo


end subroutine initialize_mean_squared_displacement

!------ A. Garhammer 2015------
subroutine deallocate_acf()
!****f* base/deallocate_acf
! FUNCTION
!    Deallocate all allocatable arrays: id_arr, time_intervalls,
!    trajectory.
!
! ARGUMENTS
!
!    ``none``
!******
if(allocated(id_arr))then
deallocate(id_arr)
else
print *,"Warning: id_arr was not allocated, tried to deallocate."
endif
if(allocated(trajectory))then
deallocate(trajectory)
else
print *,"Warning: trajectroy was not allocated, tried to deallocate."
endif


end subroutine deallocate_acf


!------ A. Garhammer 2015------
!subroutine get_lattice(return_lattice)
!****f* base/get_lattice
! FUNCTION
!    Returns the current lattice.
!
! ARGUMENTS
!
!    * ``return_lattice`` writeable 1 dimensonal array, where the current lattice will be stored.
!******
!---------------I/O variables---------------


!integer(kind=iint), dimension(5),  intent(out) :: return_lattice

!return_lattice = lattice

!end subroutine get_lattice

!------ A. Garhammer 2016------
subroutine get_displacement(return_displacement)
!****f* base/get_property
! FUNCTION
!    Returns the displacement vector.
!
! ARGUMENTS
!
!    * ``return_displacement`` writeable (nr_of_ions,3) dimensonal array, where the displacement of each particle will be stored.
!******
!---------------I/O variables---------------


real(kind=rdouble), dimension(2,3),  intent(out) :: return_displacement

return_displacement = displacement

end subroutine get_displacement

!------ A. Garhammer 2015------
subroutine allocate_acf(nr_of_types)
!****f* base/allocate_property_acf
! FUNCTION
!    Allocates the property vector, which we need for the calculation of the ACF and intializes it with zero.
!    The user have to call this subroutine, before the subroutines def_property_acf, initialize_acf and allocate_config_bin_acf can be called.
!
! ARGUMENTS
!
!    * ``none``
!******
!---------------I/O variables---------------

integer(kind = iint), intent(in) :: nr_of_types
integer(kind = iint) :: volume

call get_volume(volume)

allocate(types(nr_of_types))
types = 0

allocate(property_acf(0:volume))
property_acf = 0

allocate(property_o(volume))
property_o = 0

allocate(product_property(0:nr_of_types,0:nr_of_types))
product_property = 0

allocate(id_arr(0:volume))
id_arr = 0

allocate(site_arr(0:volume))
site_arr = 0

allocate(buffer_acf(0:volume))
buffer_acf = 0



end subroutine allocate_acf

!------ A. Garhammer 2016------
subroutine allocate_trajectory(nr_of_steps)
!****f* base/allocate_property_acf
! FUNCTION
!    Allocates the property vector, which we need for the calculation of the ACF and intializes it with zero.
!    The user have to call this subroutine, before the subroutines def_property_acf, initialize_acf and allocate_config_bin_acf can be called.
!
! ARGUMENTS
!
!    * ``none``
!******
!---------------I/O variables---------------
integer(kind = iint), intent(in) :: nr_of_steps
integer(kind = iint) :: i, volume

call get_volume(volume)

allocate(trajectory(volume, nr_of_steps + 1))
trajectory = 0

do i = 1 , volume
trajectory(i,1) = property_acf(site_arr(i))
enddo

end subroutine allocate_trajectory

!------ A. Garhammer 2016------
subroutine allocate_config_bin_acf(t_bin_arg,t_f_arg,safety_factor_arg,extended_nr_of_bins_arg)
!****f* base/allocate_config_bin_acf
! FUNCTION
!    allocate_config_bin_acf allocates and initializes the arrays and the variables for the on the fly calculation of the autocorrelation function (ACF).
!    The user must specify the number of bins and the decay time to be used for calculating the ACF.
!    From this, the bin size t_bin is calculated.
!
! ARGUMENTS
!
!    * ``nr_of_bins_in`` writeable integer, where the number of bins for the calculation of the ACF will be stored.
!    * ``t_f_in`` writeable real, where the decay time t_f of the ACF will be stored
!******
!---------------I/O variables---------------
real(kind = rdouble), intent(in) :: t_bin_arg
real(kind = rdouble), intent(in) :: t_f_arg
integer(kind = iint), intent(in), optional :: safety_factor_arg, extended_nr_of_bins_arg
integer(kind = iint) :: safety_factor, extended_nr_of_bins
real(kind = rdouble) :: kmc_time

call get_kmc_time(kmc_time)


if(.not. present(safety_factor_arg) .or. safety_factor_arg.eq.0)then
safety_factor = 2
else
safety_factor = safety_factor_arg
end if

if(.not. present(extended_nr_of_bins_arg) .or. extended_nr_of_bins_arg.eq.0)then
extended_nr_of_bins = 2
else
extended_nr_of_bins = extended_nr_of_bins_arg
end if
print *, extended_nr_of_bins , present(extended_nr_of_bins_arg)
t_f = t_f_arg * safety_factor
t_bin = t_bin_arg
nr_of_bins = int(t_f/t_bin + 1)
t_f = nr_of_bins * t_bin
print *, t_f, t_bin, nr_of_bins
allocate(config_bin(nr_of_bins * extended_nr_of_bins))
config_bin = 0
allocate(counter_write_in_bin(nr_of_bins * extended_nr_of_bins))
counter_write_in_bin = 0
bin_index = 0
wrap_count = 0
t_o = kmc_time


end subroutine allocate_config_bin_acf

!------ A. Garhammer 2016------
subroutine get_config_bin_acf(return_config_bin)
!****f* base/get_config_bin_acf
! FUNCTION
!    Returns the config_bin_acf array.
!
! ARGUMENTS
!
!    * ``return_config_bin`` writeable 1 dimensonal array, where the property average over all particles and all wraps for every bin will be stored.
!******
!---------------I/O variables---------------

real(kind=rdouble), dimension(34*3), intent(out) :: return_config_bin



return_config_bin = config_bin

end subroutine get_config_bin_acf

!------ A. Garhammer 2016------
subroutine get_counter_write_in_bin(return_counter_write_in_bin)
!****f* base/get_config_bin_acf
! FUNCTION
!    Returns the config_bin_acf array.
!
! ARGUMENTS
!
!    * ``return_config_bin`` writeable 1 dimensonal array, where the property average over all particles and all wraps for every bin will be stored.
!******
!---------------I/O variables---------------

real(kind=rdouble), dimension(34*3), intent(out) :: return_counter_write_in_bin



return_counter_write_in_bin = counter_write_in_bin

end subroutine get_counter_write_in_bin



!------ A. Garhammer 2015------
subroutine deallocate_property_acf()

if(allocated(property_acf))then
deallocate(property_acf)
else
print *,"Warning: property_acf was not allocated, tried to deallocate."
endif

end subroutine deallocate_property_acf



!------ A. Garhammer 2015------
subroutine set_property_acf(site_nr_acf,input_property_acf)
!****f* base/def_property_acf
! FUNCTION
!    def_property_acf defines the property of each site for the calculation of ACF.
!    The properties will be stored in property_acf.
!    The properties are defined by the user.
!    The user have to call this subroutine, before the subroutines initialize_acf and allocate_config_bin_acf can be called.
!
! ARGUMENTS
!
!    * ``site_nr_acf`` writeable integer, where site number will be stored.
!    * ``input_property_acf`` writeable real, where the property of the corresponding site will be stored.
!******
!---------------I/O variables---------------
integer(kind=iint), intent(in) :: site_nr_acf
integer(kind=iint), intent(in) :: input_property_acf



property_acf(site_nr_acf) = input_property_acf

end subroutine set_property_acf

!------ A. Garhammer 2015------
subroutine set_types(type_index,input_property)
!****f* base/def_property_acf
! FUNCTION
!    def_property_acf defines the property of each site for the calculation of ACF.
!    The properties will be stored in property_acf.
!    The properties are defined by the user.
!    The user have to call this subroutine, before the subroutines initialize_acf and allocate_config_bin_acf can be called.
!
! ARGUMENTS
!
!    * ``site_nr_acf`` writeable integer, where site number will be stored.
!    * ``input_property_acf`` writeable real, where the property of the corresponding site will be stored.
!******
!---------------I/O variables---------------
integer(kind=iint), intent(in) :: type_index
real(kind=rdouble), intent(in) :: input_property



types(type_index) = input_property

end subroutine set_types


!------ A. Garhammer 2016------
subroutine set_product_property(type_index_o,type_index,input_product_property)
!****f* base/def_property_acf
! FUNCTION
!    def_property_acf defines the property of each site for the calculation of ACF.
!    The properties will be stored in property_acf.
!    The properties are defined by the user.
!    The user have to call this subroutine, before the subroutines initialize_acf and allocate_config_bin_acf can be called.
!
! ARGUMENTS
!
!    * ``site_nr_acf`` writeable integer, where site number will be stored.
!    * ``input_property_acf`` writeable real, where the property of the corresponding site will be stored.
!******
!---------------I/O variables---------------
integer(kind=iint), intent(in) :: type_index_o
integer(kind=iint), intent(in) :: type_index
real(kind=rdouble), intent(in) :: input_product_property



product_property(type_index_o,type_index) = input_product_property

end subroutine set_product_property


!------ A. Garhammer 2015------
subroutine get_property_acf(return_property_acf)
!****f* base/get_property
! FUNCTION
!    Returns the property vector.
!
! ARGUMENTS
!
!    * ``return_property_acf`` writeable 1 dimensonal array, where the property_acf will be stored.
!******
!---------------I/O variables---------------

integer(kind=iint), dimension(0:5), intent(out) :: return_property_acf



return_property_acf = property_acf

end subroutine get_property_acf

!------ A. Garhammer 2016------
subroutine get_types(return_types)
!****f* base/get_property
! FUNCTION
!    Returns the property vector.
!
! ARGUMENTS
!
!    * ``return_property_acf`` writeable 1 dimensonal array, where the property_acf will be stored.
!******
!---------------I/O variables---------------

real(kind=rdouble), dimension(2), intent(out) :: return_types



return_types = types


end subroutine get_types


!------ A. Garhammer 2016------
subroutine get_product_property(return_product_property)
!****f* base/get_property
! FUNCTION
!    Returns the property vector.
!
! ARGUMENTS
!
!    * ``return_property_acf`` writeable 1 dimensonal array, where the property_acf will be stored.
!******
!---------------I/O variables---------------

real(kind=rdouble), dimension(0:2,0:2), intent(out) :: return_product_property



return_product_property = product_property

end subroutine get_product_property

!------ A. Garhammer 2016------
subroutine get_property_o(return_property_o)
!****f* base/get_property
! FUNCTION
!    Returns the property vector.
!
! ARGUMENTS
!
!    * ``return_property_acf`` writeable 1 dimensonal array, where the property_acf will be stored.
!******
!---------------I/O variables---------------

integer(kind=iint), dimension(5), intent(out) :: return_property_o



return_property_o = property_o

end subroutine get_property_o

!------ A. Garhammer 2016------
subroutine get_buffer_acf(return_buffer_acf)
!****f* base/get_property
! FUNCTION
!    Returns the property vector.
!
! ARGUMENTS
!
!    * ``return_property_acf`` writeable 1 dimensonal array, where the property_acf will be stored.
!******
!---------------I/O variables---------------

real(kind=rdouble), dimension(0:5), intent(out) :: return_buffer_acf



return_buffer_acf = buffer_acf

end subroutine get_buffer_acf




!------ A. Garhammer 2015------
subroutine get_id_arr(return_id_arr)
!****f* base/get_property
! FUNCTION
!    Returns id_arr.
!
! ARGUMENTS
!
!    * ``return_id_arr`` writeable 2 dimensonal array, where the id_arr will be stored.
!******
!---------------I/O variables---------------


integer(kind=iint), dimension(0:5)  ,intent(out) :: return_id_arr

return_id_arr = id_arr

end subroutine get_id_arr

!------ A. Garhammer 2016------
subroutine get_site_arr(return_site_arr)
!****f* base/get_property
! FUNCTION
!    Returns site_arr.
!
! ARGUMENTS
!
!    * ``return_site_arr`` writeable 2 dimensonal array, where the site_arr will be stored.
!******
!---------------I/O variables---------------


integer(kind=iint), dimension(0:5)  ,intent(out) :: return_site_arr

return_site_arr = site_arr

end subroutine get_site_arr

!------ A. Garhammer 2015------
subroutine get_trajectory(return_trajectory)
!****f* base/get_property
! FUNCTION
!    Returns the trajectory array.
!
! ARGUMENTS
!
!    * ``return_trajectory`` writeable 2 dimensonal array, where the trajectory from each kMC step will be stored.
!******
!---------------I/O variables---------------



integer(kind=iint), dimension(5,6) ,intent(out) :: return_trajectory

return_trajectory = trajectory

end subroutine get_trajectory

!------ A. Garhammer 2015------
subroutine update_trajectory(particle_id, kmc_step_acf)
!****f* base/update_trajectory
! FUNCTION
!    update_trajectory saves for each particle the property after one kmc step.
!    The property depends on the site, which is occupied by the corresponding particle.
!    This function is optional and can be turned on and off.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle which jumps will be stored.
!    * ``kmc_step_acf`` writeable integer, where the number of kmc steps from the start of the ACF calculation will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------
integer(kind = iint), intent(in) :: particle_id
integer(kind = iint), intent(in) :: kmc_step_acf


trajectory(:,kmc_step_acf+1) = trajectory(:,kmc_step_acf)
trajectory(particle_id,kmc_step_acf+1) = property_acf(site_arr(particle_id))


end subroutine update_trajectory


!------ A. Garhammer 2015------
subroutine assign_particle_id(init_site,particle_id)
!****f* base/assign_particle_id
! FUNCTION
!    assign_particle_id gives the id of the particle which jumps, in one kmc step.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!******
!---------------I/O variables---------------
integer(kind = iint) :: k
integer(kind = iint), intent(out) :: particle_id
integer(kind = iint), intent(in) :: init_site




particle_id = id_arr(init_site)
!print *, particle_id

end subroutine assign_particle_id

!------ A. Garhammer 2016------
subroutine update_displacement(particle_id,displace_coord)
!****f* base/update_displacement
! FUNCTION
!    update_displacement updates the displacement of the particle, which jumps, in one kmc step.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``displace_coord`` writeable 3 dimensonal array, where the displacement of the jumping particle will be stored.
!******
!---------------I/O variables---------------
integer(kind = iint), intent(in) :: particle_id
real(kind = rdouble), dimension(3), intent(in) :: displace_coord


displacement(particle_id,:) = displacement(particle_id,:) + displace_coord


end subroutine update_displacement

!------ A. Garhammer 2016------
subroutine calc_mean_squared_disp(mean_squared_disp)
!****f* base/calc_mean_squared_disp
! FUNCTION
!   calc_mean_squared_disp calculates the mean squared displacement after a kmc run.
!   The user have to call this subroutine after the kmc run, to get the mean squared displacement.
!
! ARGUMENTS
!
!    * ``mean_squared_disp`` writeable real, where the mean squared displacement will be stored.
!******
!---------------I/O variables---------------


integer(kind = iint) :: k
real(kind = rdouble), intent(out) :: mean_squared_disp

mean_squared_disp = 0
k = 1
do k = 1, nr_of_ions
mean_squared_disp = mean_squared_disp + sum(displacement(k,:)**2)
enddo

mean_squared_disp = mean_squared_disp / nr_of_ions


end subroutine calc_mean_squared_disp

!------ A. Garhammer 2016------
subroutine calc_acf(acf)
!****f* base/calc_acf
! FUNCTION
!   calc_acf calculates ACF after a kmc run.
!   The user have to call this subroutine after the kmc run, to get the ACF.
!
! ARGUMENTS
!
!    * ``acf`` writeable (nr_of_bins + 1) dimensional array, where the ACF will be stored.
!******
!---------------I/O variables---------------



real(kind = rdouble), dimension(34), intent(out) :: acf


acf = config_bin(:)/(wrap_count*t_bin)
print *, wrap_count


end subroutine calc_acf

!------ A. Garhammer 2015------
subroutine update_id_arr(particle_id,init_site,fin_site)
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied     after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

integer(kind = iint), intent(in) :: particle_id
integer(kind = iint), intent(in) :: fin_site
integer(kind = iint), intent(in) :: init_site

id_arr(init_site) = 0
id_arr(fin_site) = particle_id
site_arr(particle_id) = fin_site

end subroutine update_id_arr

!------ A. Garhammer 2016------
subroutine drain_process(exit_site, init_site, fin_site)
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

integer(kind = iint) :: particle_id
integer(kind = iint), intent(in) :: exit_site
integer(kind = iint), intent(out) :: init_site, fin_site


nr_of_ions_before_kmc_step_acf = nr_of_ions - 1
particle_id = id_arr(exit_site)
site_arr(particle_id) = site_arr(nr_of_ions)

id_arr(site_arr(particle_id)) = particle_id
site_arr(nr_of_ions) = 0
id_arr(exit_site) = 0
property_o(particle_id) = property_o(nr_of_ions)
property_o(nr_of_ions) = 0
init_site = site_arr(particle_id)
fin_site = site_arr(particle_id)
buffer_acf(particle_id) = buffer_acf(nr_of_ions)
buffer_acf(nr_of_ions) = 0
nr_of_ions = nr_of_ions - 1


end subroutine drain_process

!------ A. Garhammer 2016------
subroutine source_process(entry_site, init_site, fin_site)
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied     after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

integer(kind = iint), intent(in) :: entry_site
integer(kind = iint), intent(out) :: init_site, fin_site



nr_of_ions = nr_of_ions + 1
id_arr(entry_site) = nr_of_ions
site_arr(nr_of_ions) = entry_site
fin_site = entry_site
init_site = entry_site

end subroutine source_process


!------ A. Garhammer 2016------
subroutine update_buffer_acf(particle_id)
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied     after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

integer(kind = iint), intent(in) :: particle_id



buffer_acf(particle_id) = product_property(property_o(particle_id),property_acf(site_arr(particle_id)))


end subroutine update_buffer_acf


!------ A. Garhammer 2016------
subroutine update_property_and_buffer_acf()
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied     after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

integer(kind = iint) :: i, volume

call get_volume(volume)



do i = 1, volume
property_o(i) = property_acf(site_arr(i))
buffer_acf(i) = product_property(property_o(i),property_o(i))
enddo

end subroutine update_property_and_buffer_acf

!------ A. Garhammer 2016------
subroutine update_config_bin()
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied     after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

real(kind = rdouble) :: entry_bin, kmc_time, kmc_time_step

call get_kmc_time(kmc_time)
call get_kmc_time_step(kmc_time_step)

entry_bin = sum(buffer_acf)
if(entry_bin.eq.0)then
entry_bin = 0
else
entry_bin = entry_bin/nr_of_ions_before_kmc_step_acf
endif

!print *, nr_of_ions_before_kmc_step_acf, entry_bin


if(kmc_time - t_o < (bin_index + 1) * t_bin)then
config_bin(bin_index + 1) = config_bin(bin_index + 1) + entry_bin * kmc_time_step
counter_write_in_bin(bin_index + 1) = counter_write_in_bin(bin_index + 1) + 1
else

config_bin(bin_index + 1) = config_bin(bin_index + 1) + entry_bin * ((bin_index + 1) * t_bin - (kmc_time - t_o - kmc_time_step))
counter_write_in_bin(bin_index + 1) = counter_write_in_bin(bin_index + 1) + 1
bin_index = bin_index + 1
if(bin_index < nr_of_bins)then
do while((bin_index + 1) * t_bin < kmc_time - t_o)

config_bin(bin_index + 1) = config_bin(bin_index + 1) + entry_bin * t_bin
counter_write_in_bin(bin_index + 1) = counter_write_in_bin(bin_index + 1) + 1
!print * , bin_index
bin_index = bin_index + 1

enddo
!print * , bin_index
config_bin(bin_index + 1) = config_bin(bin_index + 1) + entry_bin * (kmc_time - t_o - (bin_index * t_bin))
counter_write_in_bin(bin_index + 1) = counter_write_in_bin(bin_index + 1) + 1

end if
end if


end subroutine update_config_bin

subroutine update_after_wrap_acf()
!****f* base/update_id_arr
! FUNCTION
!    update_id_arr updates id_arr after one kmc step.
!    The id of the particle, which jumps, is stored in the entry of id_arr which corresponds to the site, which is occupied     after the jump.
!    The entry of id_arr, which corresponds to the site, which is occupied by the particle before the jump, is setted to zero.
!
! ARGUMENTS
!
!    * ``particle_id`` writeable integer, where the id of the particle, which jumps will be stored.
!    * ``init_site`` writeable integer, where the number of the site, from which the particle jumps away will be stored.
!    * ``fin_site`` writeable integer, where the number of the site, in which the particle jumps will be stored.
!******
!---------------I/O variables---------------

real(kind = rdouble) :: kmc_time

call get_kmc_time(kmc_time)

if(bin_index > nr_of_bins - 1)then
t_o = kmc_time
bin_index = 0
wrap_count = wrap_count + 1
call update_property_and_buffer_acf()
call update_nr_of_ions_before_kmc_step_acf()
end if

end subroutine update_after_wrap_acf

!------ A. Garhammer 2015------
!subroutine update_clocks_acf(ran_time)
!****f* base/update_clocks_acf
! FUNCTION
!    Updates walltime, kmc_step, kmc_step_acf, time_intervalls and kmc_time.
!
! ARGUMENTS
!
!    * ``ran_time`` Random real number :math:`\in [0,1]`
!******
!real(kind=rsingle), intent(in) :: ran_time
!real(kind=rsingle) :: runtime


! Make sure ran_time is in the right interval
!ASSERT(ran_time.ge.0.,"base/update_clocks: ran_time variable has to be positive.")
!ASSERT(ran_time.le.1.,"base/update_clocks: ran_time variable has to be less than 1.")

!kmc_time_step = -log(ran_time)/accum_rates(nr_of_proc)
! Make sure the difference is not so small, that it is rounded off
! ASSERT(kmc_time+kmc_time_step>kmc_time,"base/update_clocks: precision of kmc_time is not sufficient")

!call CPU_TIME(runtime)

! Make sure we are not dividing by zero
!ASSERT(accum_rates(nr_of_proc).gt.0,"base/update_clocks: total rate was found to be zero")
!kmc_time = kmc_time + kmc_time_step
!kmc_time_acf = kmc_time_acf + kmc_time_step
! Increment kMC steps
!kmc_step = kmc_step + 1
!kmc_step_acf = kmc_step_acf + 1


! Walltime is the time of this simulation run plus the walltime
! when the simulation was reloaded, so walltime represents the total
! walltime across reloads.
!walltime = start_time + runtime
!------ S. Matera 09/18/2012------
!-- 'call update_integ_rate()' is now directly called in do_kmc_step(s)
!call update_integ_rate()
!------ S. Matera 09/18/2012------
!end subroutine update_clocks_acf

!------ A. Garhammer 2015------
!subroutine get_kmc_step_acf(return_kmc_step_acf)
!****f* base/get_kmc_step_acf
! FUNCTION
!    Return the current kmc_step_acf
!
! ARGUMENTS
!
!    * ``kmc_step_acf`` Writeable integer
!******
!---------------I/O variables---------------
!integer(kind=iint), intent(out) :: return_kmc_step_acf

!return_kmc_step_acf = kmc_step_acf

!end subroutine get_kmc_step_acf



end module base_acf
