##########################################################
##### Self-Evolving L-Peptides Algorithm Version 1.5 #####
##########################################################

The self-evolving peptide algorithm (SEPA) is a shell script (Bash), there are no installation required to use the script. 

There are several prerequisite software that need to be installed before the SEPA script can be executed: 
1. AutoDock Vina
2. HBPLUS
3. MGLTools
4. Open Babel
5. PyMOL

The SEPA script was tested using Ubuntu version 16.04. By using Ubuntu version 16.04 as an example, AutoDock Vina, Open Babel, and PyMOL can be installed with the command 'apt-get install autodock-vina openbabel pymol'. MGLTools and HBPLUS required the user to download the software from their respective website and installed manually according to their respective instructions. We recommend to place all the manually installed software in the home directory to avoid potential directory identification and permission problems. If the user uses the SEPA script, please remember to cite these software too. 

The SEPA script requires several prerequisite files before running:
1. The pdbqt format of the receptor file.
2. The configuration files for AutoDock Vina (conf.txt, conf100e.txt). 
3. A Python script for construction of peptide (amac.py).
4. Amino acid residue list consists of the 20 basic amino acid residues (aalist). 

There are three files that requires manual input from the user, one receptor pdbqt file and two configuration file (conf.txt, conf100e.txt). The user are required to provide the receptor file in pdbqt format. The user are also required to modify the configuration files (conf.txt, conf100e.txt) to specify center and size of grid box, and the name of the receptor. The template for the configuration files were included in the shared google drive link to download the SEPA script. The Python script (amac.py) and amino acid residue list (aalist) will be included in the shared google drive link, both file does not require any further modification and can be used to run the SEPA script as it is. 

To use the SEPA script, the user has to place all the files downloaded from the SEPA shared google drive in the same directory as the receptor pdbqt file. Upon the execution of the SEP algorithm script, the user will be required to input the number of amino acids for the generation of peptide, and specify the number, and specific amino acid residues on the receptor's binding site that the user would like to analyze the binding interaction with the small peptides. The SEPA script will prompt the user to confirm the input before the execution actually begins. 

In case the script cannot be executed due to permission issue, type the following command in the terminal:
chmod +x sepa1.5.sh

To run the script, simply type the following command in the terminal:
./sepa1.5.sh

After the SEPA script started running, a parameter file (that has the suffix .param) would be generated. The parameter file recorded all the entries input by the user during the initial prompt. This is a convenient reference for the user. 

After each stage of SEPA, several files would be produced on the directory that the user run the SEPA script. The file looks something as follows:
1. 'name'-l?aa-fast-summary.txt
2. 'name'-l?aa-top200-binding-affinity.txt
3. 'name'-l?aa-top200-binding-percentage.txt

The 'name' part indicates the receptor name that the user assigned to the receptor pdbqt file. After the first hyphen, the 'l?aa' indicates the length of peptide. In this example, `l2aa' refers to dipeptide, 'l3aa' refers to tripeptide, and so on. 

The '-fast-summary.txt' file is a simplified version of the binding affinity file, where only the best binding affinity was recorded for all the virtually screened peptides.

The '-top200-binding-affinity.txt' file generated based on thorough docking of top 200 peptides in '-fast-summary.txt' file. It ranks all the docked conformations with binding affinity calculated by AutoDock Vina. Since 5 runs were carried out (thorough docking), the first conformation of each run was compared. The most negative value and the least negative value of first conformation of all the 5 runs were recorded on the list. 

The '-top200-binding-percentage.txt' file ranks all the docked conformations that have hydrogen bond interactions with the important amino acid residues on the receptor (as specified in the beginning of the prompt of the SEPA script), represented in percentage. The final result should be available in the file 'name'-l?aa-top200-binding-percentage.txt where ? is the defined number of amino acid (length of peptide) in the final generation of peptides.



Thank you for using Self-Evolving Peptide algorithm!

by

Tan Ke Han (tankehan321@gmail.com), Chin Sek Peng (spchin@um.edu.my) & Heh Choon Han (silverbot@um.edu.my)

Faculty of Pharmacy, Universiti Malaya, Malaysia

Citation: Tan, K. H., Chin, S. P., & Heh, C. H. (2022). Automated in silico EGFR Peptide Inhibitor Elongation using Self-evolving Peptide Algorithm. Current computer-aided drug design, 18(2), 150–158. https://doi.org/10.2174/1573409918666220516144300
