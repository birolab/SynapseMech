# SynapseMech

SynapseMech is an image analysis platform to study morphologies and curvatures during cell-cell interactions.

This code was released as part of the following publication - PLEASE CITE UPON USE:
"T cell cytoskeletal forces shape synapse topography for targeted lysis via membrane curvature bias of perforin"
by Matt A. Govendir, Daryan Kempe, Setareh Sianati, James Cremasco, Jessica K. Mazalo, Feyza Colakoglu, Matteo Golo, Kate Poole, and Maté Biro
Developmental Cell (2022) [In press]

SynapseMech was developed with a focus on imaging data generated with a dual-pipette-aspiration setup, but is also applicable to
other 3D cell-cell interaction scenarios. 

Export_SynapseMech.m is a Bitplane Imaris XTension used to export the segmented imaging data in a format compatible with SynapseMech.m.
At this stage it is only compatible with Imaris 8.4.1 (or earlier versions). 

Information on how the imaging data needs to be prepared using Imaris is given in the Export_SynapseMech.m script, 
and can also be found in the ExampleCurvatureMap_Segmentation.png.

ExampleCurvatureMap_Export_SynapseMech.mat is an example output created with Export_SynapseMech.m to then be analysed using
SynapseMech.m. Use it as an input for SynapseMechDemo.m to see how outputs like curvature maps, degranulation pockets or tail volume curves 
can be retrieved and visualised.





Code is provided under the GNU General Public Licence version 3.0 as part of the above publication. Please cite upon use.
