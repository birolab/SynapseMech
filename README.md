# SynapseMech

SynapseMech is an image analysis platform to study morphologies and curvatures during cell-cell interactions.

This code was released as part of the following publication - PLEASE CITE UPON USE:

Matt A. Govendir, Daryan Kempe, Setareh Sianati, James Cremasco, Jessica K. Mazalo, Feyza Colakoglu, Matteo Golo, Kate Poole, Maté Biro,
T cell cytoskeletal forces shape synapse topography for targeted lysis via membrane curvature bias of perforin,
Developmental Cell,2022. https://doi.org/10.1016/j.devcel.2022.08.012

SynapseMech was developed with a focus on imaging data generated with a dual-pipette-aspiration setup, but is also applicable to
other 3D cell-cell interaction scenarios. 

Export_SynapseMech.m is a Bitplane Imaris XTension used to export the segmented imaging data in a format compatible with SynapseMech.m.
At this stage it is only compatible with Imaris 8.4.1 (or earlier versions). 

Information on how the imaging data needs to be prepared using Imaris is given in the Export_SynapseMech.m script, 
and can also be found in the Export_SynapseMech_SegmentationExample.png.

To run successfully, SynapseMech.m requires the scripts located in the SynapseMechSub folder. 
Therefore, the SynapseMechSub folder must either be located in the same directory as SynapseMech.m, 
or must be added to the Matlab search path by the user.

Copyright Daryan Kempe, 2018-2022, UNSW Sydney

email: d (dot) kempe (at) unsw (dot) edu (dot) au


Code is provided under the GNU General Public Licence version 3.0 as part of the above publication. Please cite upon use.
