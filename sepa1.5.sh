#!/bin/bash


#### Intro ####

echo

echo "##############################################"
echo "##### Self Evolving L-Peptides Version 1.5 #####"
echo "##############################################"

#### To extract macromolecule's name from conf.txt ####

#### name=$(grep receptor conf.txt | tr "=" "\n" | awk NR==2 | sed 's/ //g' | sed 's/.pdbqt//g')

#### nameqt=$(grep receptor conf.txt | tr "=" "\n" | awk NR==2 | sed 's/ //g')

#### To key in macromolecule's name ####

echo

read -p "Enter your enzyme's or receptor's name (case senitive in as the filename) without the .pdbqt extension: " name

### Check for error ###

if [ "$name" == "" ] ; then echo; echo "Please enter something!!!"; exit; fi

echo

sleep 0.5

#### Entering length of peptides generation ####

read -p "Please enter the number of amino acids for the l-peptide generation (3-6): " xxx

echo $xxx

#### Check for peptide length ####

if [[ "$xxx" -lt 3 || "$xxx" -gt 6 || "$xxx" == "" ]]; then echo; echo "Only can enter 3 - 6!!!"; exit; fi

echo

sleep 0.5


#### Selecting binding site ####

read -p "How many amino acid residues of your macromolecule's binding site that you would like to analyze the binding interaction with the small peptides? (Max 5) > " aanum

### Check for error ###

if [[ "$aanum" == 0 || "$aanum" > 5  || "$aanum" == "" ]] ; then echo; echo "Only can enter 1 - 5!!!"; exit; fi

echo 

for n in $(seq 1 $aanum); do read -p "Please enter amino acid residue No."$n" (format: ChainID-3LetterAminoAcidInCap-ResidueID-AtomID, eg: A-ALA-111-OD1) > " aar$n; done  

if [[ "$aar1" == "" ]] ; then echo; echo "Please enter correctly!!!"; exit; fi;

echo

sleep 0.5


#### End of checking ####

#### Display and confirm the parameters ####

echo "Please check your parameters below:"

echo "----------------------------------"

echo "Your macromolecule is: "$name.pdbqt

echo 

sleep 2

echo "Number of amino acids for the l-peptides you would like to generate is: " $xxx

echo

sleep 2

case $aanum in

1) echo "Your macromolecule binding site's amino acid residue is: " $aar1 ;;

2) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 ;;

3) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 "," $aar3 ;;

4) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 "," $aar3 "," $aar4 ;;

5) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 "," $aar3 "," $aar4 "," $aar5 ;;

*) echo "Parameter(s) entered wrongly!" ;;

esac

echo

sleep 2

read -p "Correct? Type Y for yes or N for no :" answer

if [[ "$answer" != "y" && "$answer" != "Y" ]] ; then echo; echo "Please rerun.."; exit; fi


#### Saving parameters as logfile ####

echo "SEP parameters:" > SEP-"$(date '+%Y%m%d_%H%M%S')".param

echo "----------------------------------" >> SEP-"$(date '+%Y%m%d_%H%M%S')".param

echo "Your macromolecule is: " $nameqt >> SEP-"$(date '+%Y%m%d_%H%M%S')".param

echo >> SEP-"$(date '+%Y%m%d_%H%M%S')".param

echo "Number of amino acids for the l-peptides you would like to generate is: " $xxx >> SEP-"$(date '+%Y%m%d_%H%M%S')".param

echo >> SEP-"$(date '+%Y%m%d_%H%M%S')".param

case $aanum in

1) echo "Your macromolecule binding site's amino acid residue is: " $aar1 >> SEP-"$(date '+%Y%m%d_%H%M%S')".param ;; 

2) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 >> SEP-"$(date '+%Y%m%d_%H%M%S')".param ;;

3) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 "," $aar3 >> SEP-"$(date '+%Y%m%d_%H%M%S')".param ;;

4) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 "," $aar3 "," $aar4 >> SEP-"$(date '+%Y%m%d_%H%M%S')".param ;;

5) echo "Your macromolecule binding site's amino acid residue is: " $aar1 "," $aar2 "," $aar3 "," $aar4 "," $aar5 >> SEP-"$(date '+%Y%m%d_%H%M%S')".param ;;

esac

echo >> SEP-"$(date '+%Y%m%d_%H%M%S')".param


#### Count down ####

echo

echo "Self Evolving L-Peptides Will Start Generating In:"

sleep 2; echo 5; sleep 1; echo 4; sleep 1; echo 3; sleep 1; echo 2; sleep 1; echo 1


#### Record the time ####

echo "Start time: " $(date) > $name-time.txt

#### End of time recording ####


#### Setting up parameters ####

mgld=$(grep -i mgl /home/$USER/.bashrc | grep adt | awk NR==1 | tr "'" "\n" | awk NR==2 | sed 's@/bin/adt@@g')

hbd=$(grep -i hbplus /home/$USER/.bashrc | grep export | tr "'" "\n" | awk NR==2)

tas=y

#### Creating l2aa peptides ####

### Creating folders for l2aa generation ###

mkdir l2aa-pgen

for num in {1..20}; do aa3=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aa3; cd l2aa-pgen; mkdir $aa3; cd ..; done

cd l2aa-pgen

for a in {1..20}; do echo $a; res1=$(cat ../aalist | awk NR==$a | tr "|" "\n"| awk NR==2); a2t=$(cat ../aalist | awk NR==$a | tr "|" "\n"| awk NR==3); echo $res1; rm $res1-aa.txt; for b in {1..20}; do echo $b; res2=$(cat ../aalist | awk NR==$b | tr "|" "\n"| awk NR==2); echo $res1$res2; echo $res1$res2 >> $a2t/$res1-aa.txt; done; done

### Create l2aa peptides using pymol ###

for num in {1..20}; do a2=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a2t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a2; echo $a2t; file=$a2-aa.txt; cd $a2t; cp ../../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'2'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done; cd ..; done

### Preparing pdbqt from pdb ###

for num in {1..20}; do a2=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a2t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a2; echo $a2t; cd $a2t; for aa in ??.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done; cd ..; done

cd ..

### Creating docking folders for l2aa ###

mkdir l2aa

for num in {1..20}; do aa3=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aa3; cd l2aa; mkdir $aa3; cd ..; done

cd l2aa-pgen

### Moving l2aa peptides pdbqt to new folder ###

for num in {1..20}; do a2t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a2t; cd $a2t; cp *.pdbqt ../../l2aa/$a2t/; cd ..; done

cd ..

cd l2aa

for a in ???; do echo $a; cd $a; for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done; cd ..; done

cd ..

#### End of l2aa peptides generation and preparation ####


#### Start screening for l2aa peptides ####

cd l2aa

for f in ???; do echo $f; cd $f; for d in ??; do echo $d; cd $d; rm $name.pdbqt conf.txt ; cd ..; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ??; do echo $d; cp ../../$name.pdbqt ../../conf.txt $d/; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ??; do echo $d; cd $d; vina --config conf.txt --ligand "$d".pdbqt --out "$d"_out.pdbqt --log log"$d".txt; cd ..; done; cd ..; done

cd ..

#### End of l2aa peptides screening ####


#### Start fast analysis of l2aa peptides #### ala arg asn asp cys gln glu gly his ile leu lys met phe pro ser thr trp tyr val

cd l2aa

rm "$name"-l2aa-pre.txt; for f in ???; do echo $f; cd $f; for d in ??; do echo $d; cd $d; z=$(grep "0\.000" log"$d".txt); e=$(echo $z | tr " " "\n" | awk NR==2); echo $d "|" $e >> ../../"$name"-l2aa-pre.txt; cd ..; done; cd ..; done

cat "$name"-l2aa-pre.txt | sort -k2n -t"|" > "$name"-l2aa-pre.sort

echo "$name" > "$name"-l2aadb-fsummary-e.sort; cat "$name"-l2aa-pre.sort | sort -k2n -t"|" >> "$name"-l2aadb-fsummary-e.sort; 

cd ..

#### End of fast l2aa peptides analysis ####


#### l2aa Summary ####

echo "l2aa peptides ranking based on binding affinity (free energy of binding)" > "$name"-l2aa-fast-summary.txt

echo " " >> "$name"-l2aa-fast-summary.txt

cd l2aa

cat "$name"-l2aadb-fsummary-e.sort >> ../"$name"-l2aa-fast-summary.txt


cd ..

echo " " >> "$name"-l2aa-fast-summary.txt

echo " " >> "$name"-l2aa-fast-summary.txt


#### End of summary ####

#### Generating top 200 l2aa peptides ####

### Creating folder ###

mkdir l2aa200-pgen

rm l2aa200.txt

### Retrieve top 200 l2aa peptides (need to mkdir ???-pgen first) {2..201} ###

cd l2aa

file=$name-l2aadb-fsummary-e.sort

for a in {2..201}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3 >> ../l2aa200-pgen/l2aa200.txt ; done

cd ..

### Create top 200 l2aa peptides using pymol ###

cd l2aa200-pgen

file=l2aa200.txt; cp ../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'2'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done

### Preparing pdbqt from pdb ###

for aa in ??.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done

cd ..

### Creating docking folders for l3aa100 ###

mkdir l2aa200

### Moving l3aa100 peptides pdbqt to new folder ###

cd l2aa200-pgen

cp *.pdbqt ../l2aa200/

cd ..

cd l2aa200

for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done

cd ..

#### End of l2aa200 peptides generation and preparation ####


#### Start screening for l3aa100 peptides ####

cd l2aa200

for f in ??; do echo $f; cd $f; rm $name.pdbqt conf.txt ; cd ..; done

for f in ??; do echo $f; cp ../$name.pdbqt ../conf100e.txt $f/; done

for f in ??; do echo $f; cd $f; for d in {1..5}; do echo $d; vina --config conf100e.txt --ligand $f.pdbqt --out "$f"v"$d"_out.pdbqt --log log"$f"v"$d".txt; done; cd ..; done

cd ..

#### End of l2aa200 peptides screening ####


#### Start l2aa200 peptides analysis ####

cd l2aa200

### Create folder and store separately ###

for f in ??; do echo $f; cd $f; for d in {1..5}; do echo $d; mkdir "$f"v"$d"; mv "$f"v"$d"_out.pdbqt log"$f"v"$d".txt "$f"v"$d"/; cp $name.pdbqt "$f"v"$d"/; done; cd ..; done

### Splitting files ###

for f in ??; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; rm -r *-??? *.pdb; for x in *out.pdbqt; do echo $x; csplit -k -s -n 3 -f "$f"v"$d"- $x '%^MODEL%' '/^MODEL/' '{*}'; done; for z in "$f"v"$d"-???; do echo $z; filename="$z".pdb; echo $filename; mv $z $filename; done; cd ..; done; cd ..; done

### Fixing broken peptides ###

for f in ??; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; for x in *-???.pdb; do echo $x; z=`basename $x .pdb`; echo $z; rm $z-fixed.pdb; for a in {1..3}; do echo $a; grep "X   $a" $x >> $z-fixed.pdb; done; done; cd ..; done; cd ..; done

### Preparation for hbplus ###

for z in ??; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for f in *-???.pdb; do echo $f; fd=$(echo $f | sed 's/.pdb//g'); mkdir $fd; cp $f $fd/; cp $fd-fixed.pdb $fd/; cp $name.pdbqt $fd/; cd $fd; num=$(grep MODEL $f); n=$(echo $num | tr " " "\n" | awk NR==2); data=$(grep VINA $f); e=$(echo $data | tr " " "\n" | awk NR==4); r=$(echo $data | tr " " "\n" | awk NR==6); filename="$name"_"$fd"_"$n"_"$e"_"$r"; mv $name.pdbqt $filename.pdbqt; grep ATOM $fd-fixed.pdb > $filename.pdb; grep TER "$f" >> $filename.pdb; sed -i 's/ATOM  /HETATM/g' $filename.pdb; grep HETATM $filename.pdb >> $filename.pdbqt; grep TER $filename.pdb >> $filename.pdbqt; cd ..; done; cd ..; done; cd ..; done

### Running hbplus ### 
for z in ??; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for a in *-???; do echo $a; cd $a; $hbd/hbplus -a 75 -d 4.9 -h 4.5 *pdbqt; grep X0 *hb2 > xhb.txt; cd ..; done; cd ..; done; cd ..; done 

#### Analysis of hbplus result ####
for a in ??; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; rm ussimposummary.txt; echo "Group | Compound | Rank | Affinity | RMSD | Acceptor | Donor | IF" > ussimposummary.txt; for z in *-???; do echo $z; cd $z; for f in *.pdbqt; do echo $f; group=$(echo $f | tr "_" "\n" | awk NR==1); comp=$(echo $f | tr "_" "\n" | awk NR==2); rank=$(echo $f | tr "_" "\n" | awk NR==3); emin=$(echo $f | tr "_" "\n" | awk NR==4); clus=$(echo $f | tr "_" "\n" | awk NR==5); cl=$(echo $clus | sed 's/.pdbqt//g'); ifreq=0; acpx=; acp=; acpn=1; acpo=; donx=; don=; donn=1; dono=; n=0; num=$(cat xhb.txt | wc -l); for b in $(seq 1 $num); do echo $b; s=$(cat xhb.txt | awk NR==$b | tr " " "\n"); r1=$(echo $s | tr " " "\n"| awk NR==1); res1=$(echo ${r1:6:3}); ch1=$(echo ${r1:0:1}); id1=$(echo ${r1:2:3}); atm1=$(echo $s | tr " " "\n"| awk NR==2); r2=$(echo $s | tr " " "\n"| awk NR==3); res2=$(echo ${r2:6:3}); ch2=$(echo ${r2:0:1}); id2=$(echo ${r2:2:3}); atm2=$(echo $s | tr " " "\n"| awk NR==4); if [ "$ch1" == "X" ] && [ "$ch2" != "X" ]; then acp=$(echo $ch2-$res2-$id2-$atm2-a); let ifreq++; elif [ "$ch2" == "X" ] && [ "$ch1" != "X" ]; then don=$(echo $ch1-$res1-$id1-$atm1-d); let ifreq++; fi; if [ "$acp-$acpn" == "$acpo-$acpn" ]; then let acpn++; elif [ "$acp-$acpn" != "$acpo-$acpn" ]; then acpn=1; fi; if [ "$acpx" == "" ] && [ "$acp" != "" ]; then acpx=$(echo $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" != "$acpo" ]; then acpx=$(echo $acpx "," $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" == "$acpo" ]; then let n=acpn-1; acpx=$(echo $acpx | sed s/"$acp"-"$n"/"$acp"-"$acpn"/g); fi; acpo=$(echo $acp-$acpn); acp=; if [ "$don-$donn" == "$dono-$donn" ]; then let donn++; elif [ "$don-$donn" != "$dono-$donn" ]; then donn=1; fi; if [ "$donx" == "" ] && [ "$don" != "" ]; then donx=$(echo $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" != "$dono" ]; then donx=$(echo $donx "," $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" == "$dono" ]; then let n=donn-1; donx=$(echo $donx | sed s/"$don"-"$n"/"$don"-"$donn"/g); fi; dono=$(echo $don-$donn); don=; done; echo $acpx; echo $donx; echo $ifreq; echo $group "|" $comp "|" $rank "|" $emin "|" $cl "|" $acpx "|" $donx "|" $ifreq >> ../ussimposummary.txt; done; cd ..; cat ussimposummary.txt | sort -k4n -t"|" > ussimposummary-aff.sort; cat ussimposummary.txt | sort -k9nr -t"|" > ussimposummary-lif.sort; done; cd ..; done; cd ..; done

### Analysis of binding interactions ###

case $aanum in
1 )  for a in ??; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
2 )  for a in ??; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
3 )  for a in ??; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
4 )  for a in ??; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
5 )  for a in ??; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4|$aar5" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

### With percentage ###

for a in ??; do echo $a; rm "$name"-"$a"-orisummary.txt; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; l=$(cat orisite-aff.sort | wc -l); e=$(cat orisite-aff.sort | tr "|" "\n" | awk NR==4); r=$(ls *fixed.pdb | wc -l); echo $a"v"$x "|" $e "|" $l "|" $l"/"$r >> ../../"$name"-"$a"-orisummary.txt; cd ..; done; cd ..; done

for a in ??; do echo $a; rm "$name"-"$a"-orisummary-e.sort; cat "$name"-"$a"-orisummary.txt | sort -k2n -k3nr -t"|" >> "$name"-"$a"-orisummary-e.sort; rm "$name"-"$a"-orisummary-p.sort; cat "$name"-"$a"-orisummary.txt | sort -k3nr -k2n -t"|" >> "$name"-"$a"-orisummary-p.sort; done

for a in ??; do echo $a; rm "$name"-"$a"-totalorisummary-e.sort; tl=0; tr=0; for x in {1..5}; do echo $x; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); l=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==3); r=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==4 | tr "/" "\n" | awk NR==2); let tl=tl+l; let tr=tr+r; p=$(bc <<< 'scale=3;'$tl'/'$tr'*100'); echo $a "|" $e "|" $l "|" $l"/"$r "|" $tl "|" $tl"/"$tr "|" $p >> "$name"-"$a"-totalorisummary-e.sort; done; done

### With Max and Min Binding Affinity ###

rm "$name"-all-orisummary.txt; for a in ??; do echo $a; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==1 | tr "|" "\n" | awk NR==2); p=$(cat "$name"-"$a"-totalorisummary-e.sort | awk NR==5 | tr "|" "\n" | awk NR==7); emin=-20.0; for x in {1..5}; do echo $x; ex=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); echo $ex; if [[ '$ex' > '$emin' || $ex == $emin ]] && [ $ex != "" ]; then emin=$ex; echo $emin; else emin=$emin; echo $emin; fi; done; echo $a "|" $e "|" $emin "|" $p >> "$name"-all-orisummary.txt; done; 

### Pre-Summary ###

case $aanum in
1 )  echo "$name > $aar1" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
2 )  echo "$name > $aar1|$aar2" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
3 )  echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
4 )  echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
5 )  echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

cd ..

#### End of l2aa200 peptides analysis ####


#### l2aa200 Summary ####

echo "Top l2aa peptides ranking based on binding affinity (free energy of binding)" > "$name"-l2aa-top200-binding-affinity.txt

echo " " >> "$name"-l2aa-top200-binding-affinity.txt

echo "Top l2aa peptides ranking based on binding percentage" > "$name"-l2aa-top200-binding-percentage.txt

echo " " >> "$name"-l2aa-top200-binding-percentage.txt

cd l2aa200

cat "$name"-all-orisummary-e.sort >> ../"$name"-l2aa-top200-binding-affinity.txt

cat "$name"-all-orisummary-p.sort >> ../"$name"-l2aa-top200-binding-percentage.txt

cd ..

echo " " >> "$name"-l2aa-top200-binding-affinity.txt

echo " " >> "$name"-l2aa-top200-binding-affinity.txt

echo " " >> "$name"-l2aa-top200-binding-percentage.txt

echo " " >> "$name"-l2aa-top200-binding-percentage.txt


#### End of summary ####


#### Record the time ####

echo "l2aa End time: " $(date) >> $name-time.txt

#### End of time recording ####



#### Creating l3aa peptides ####

### Creating folders for l3aa generation ###

mkdir l3aa-pgen

for num in {1..20}; do aa3=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aa3; cd l3aa-pgen; mkdir $aa3; cd ..; done

cd l2aa200

### Retrieve top 100 l2aa peptides (need to mkdir ???-pgen first) {2..101} ###

file="$name"-all-orisummary-p.sort

for a in {2..101}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3; for num in {1..20}; do a3=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a3t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a3; echo $a3t; echo $aa3$a3 >> ../l3aa-pgen/$a3t/l2aa-$a3.txt ; done; done

cd ..

cd l3aa-pgen

### Create l3aa peptides using pymol ###

for num in {1..20}; do a3=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a3t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a3; echo $a3t; file=l2aa-$a3.txt; cd $a3t; cp ../../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'3'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done; cd ..; done

### Preparing pdbqt from pdb ###

for num in {1..20}; do a3=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a3t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a3; echo $a3t; cd $a3t; for aa in ???.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done; cd ..; done

cd ..

### Creating docking folders for l3aa ###

mkdir l3aa

for num in {1..20}; do aa3=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aa3; cd l3aa; mkdir $aa3; cd ..; done

cd l3aa-pgen

### Moving l3aa peptides pdbqt to new folder ###

for num in {1..20}; do a3t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a3t; cd $a3t; cp *.pdbqt ../../l3aa/$a3t/; cd ..; done

cd ..

cd l3aa

for a in ???; do echo $a; cd $a; for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done; cd ..; done

cd ..

#### End of l3aa peptides generation and preparation ####


#### Start screening for l3aa peptides ####

cd l3aa

for f in ???; do echo $f; cd $f; for d in ???; do echo $d; cd $d; rm $name.pdbqt conf.txt ; cd ..; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ???; do echo $d; cp ../../$name.pdbqt ../../conf.txt $d/; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ???; do echo $d; cd $d; vina --config conf.txt --ligand "$d".pdbqt --out "$d"_out.pdbqt --log log"$d".txt; cd ..; done; cd ..; done

cd ..

#### End of l3aa peptides screening ####


#### Creating docking backup for l3aa peptides ####

cp -r l3aa/ l3aa-bk

#### End of l3aa backup creation ####


#### Start fast l3aa peptides analysis #### ala arg asn asp cys gln glu gly his ile leu lys met phe pro ser thr trp tyr val

cd l3aa

rm "$name"-l3aa-pre.txt; for f in ???; do echo $f; cd $f; for d in ???; do echo $d; cd $d; z=$(grep "0\.000" log"$d".txt); e=$(echo $z | tr " " "\n" | awk NR==2); echo $d "|" $e >> ../../"$name"-l3aa-pre.txt; cd ..; done; cd ..; done

cat "$name"-l3aa-pre.txt | sort -k2n -t"|" > "$name"-l3aa-pre.sort

echo "$name" > "$name"-l3aadb-fsummary-e.sort; cat "$name"-l3aa-pre.sort | sort -k2n -t"|" >> "$name"-l3aadb-fsummary-e.sort; 

cd ..

#### End of fast l3aa peptides analysis ####


#### l3aa Fast Summary ####

echo "l3aa peptides ranking based on binding affinity (free energy of binding)" >> "$name"-l3aa-fast-summary.txt

echo " " >> "$name"-l3aa-fast-summary.txt

cd l3aa

cat "$name"-l3aadb-fsummary-e.sort >> ../"$name"-l3aa-fast-summary.txt

cd ..

echo " " >> "$name"-l3aa-fast-summary.txt

echo " " >> "$name"-l3aa-fast-summary.txt

#### End of summary ####


#### run full hbplus analysis and summary with condition ####

if [[ "$tas" == "y" || "$tas" == "Y" ]] ; then


#### Generating top 200 l3aa peptides ####

### Creating folder ###

mkdir l3aa200-pgen

rm l3aa200.txt

### Retrieve top 200 l3aa peptides (need to mkdir ???-pgen first) {2..201} ###

cd l3aa

file=$name-l3aadb-fsummary-e.sort

for a in {2..201}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3 >> ../l3aa200-pgen/l3aa200.txt ; done

cd ..

### Create top 200 l3aa peptides using pymol ###

cd l3aa200-pgen

file=l3aa200.txt; cp ../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'3'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done

### Preparing pdbqt from pdb ###

for aa in ???.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done

cd ..

### Creating docking folders for l3aa200 ###

mkdir l3aa200

### Moving l3aa200 peptides pdbqt to new folder ###

cd l3aa200-pgen

cp *.pdbqt ../l3aa200/

cd ..

cd l3aa200

for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done

cd ..

#### End of l3aa200 peptides generation and preparation ####


#### Start screening for l3aa200 peptides ####

cd l3aa200

for f in ???; do echo $f; cd $f; rm $name.pdbqt conf.txt ; cd ..; done

for f in ???; do echo $f; cp ../$name.pdbqt ../conf100e.txt $f/; done

for f in ???; do echo $f; cd $f; for d in {1..5}; do echo $d; vina --config conf100e.txt --ligand $f.pdbqt --out "$f"v"$d"_out.pdbqt --log log"$f"v"$d".txt; done; cd ..; done

cd ..

#### End of l3aa200 peptides screening ####


#### Start l3aa200 peptides analysis ####

cd l3aa200

### Create folder and store separately ###

for f in ???; do echo $f; cd $f; for d in {1..5}; do echo $d; mkdir "$f"v"$d"; mv "$f"v"$d"_out.pdbqt log"$f"v"$d".txt "$f"v"$d"/; cp $name.pdbqt "$f"v"$d"/; done; cd ..; done

### Splitting files ###

for f in ???; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; rm -r *-??? *.pdb; for x in *out.pdbqt; do echo $x; csplit -k -s -n 3 -f "$f"v"$d"- $x '%^MODEL%' '/^MODEL/' '{*}'; done; for z in "$f"v"$d"-???; do echo $z; filename="$z".pdb; echo $filename; mv $z $filename; done; cd ..; done; cd ..; done

### Fixing broken peptides ###

for f in ???; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; for x in *-???.pdb; do echo $x; z=`basename $x .pdb`; echo $z; rm $z-fixed.pdb; for a in {1..3}; do echo $a; grep "X   $a" $x >> $z-fixed.pdb; done; done; cd ..; done; cd ..; done

### Preparation for hbplus ###

for z in ???; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for f in *-???.pdb; do echo $f; fd=$(echo $f | sed 's/.pdb//g'); mkdir $fd; cp $f $fd/; cp $fd-fixed.pdb $fd/; cp $name.pdbqt $fd/; cd $fd; num=$(grep MODEL $f); n=$(echo $num | tr " " "\n" | awk NR==2); data=$(grep VINA $f); e=$(echo $data | tr " " "\n" | awk NR==4); r=$(echo $data | tr " " "\n" | awk NR==6); filename="$name"_"$fd"_"$n"_"$e"_"$r"; mv $name.pdbqt $filename.pdbqt; grep ATOM $fd-fixed.pdb > $filename.pdb; grep TER "$f" >> $filename.pdb; sed -i 's/ATOM  /HETATM/g' $filename.pdb; grep HETATM $filename.pdb >> $filename.pdbqt; grep TER $filename.pdb >> $filename.pdbqt; cd ..; done; cd ..; done; cd ..; done

### Running hbplus ### 
for z in ???; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for a in *-???; do echo $a; cd $a; $hbd/hbplus -a 75 -d 4.9 -h 4.5 *pdbqt; grep X0 *hb2 > xhb.txt; cd ..; done; cd ..; done; cd ..; done 

#### Analysis of hbplus result ####
for a in ???; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; rm ussimposummary.txt; echo "Group | Compound | Rank | Affinity | RMSD | Acceptor | Donor | IF" > ussimposummary.txt; for z in *-???; do echo $z; cd $z; for f in *.pdbqt; do echo $f; group=$(echo $f | tr "_" "\n" | awk NR==1); comp=$(echo $f | tr "_" "\n" | awk NR==2); rank=$(echo $f | tr "_" "\n" | awk NR==3); emin=$(echo $f | tr "_" "\n" | awk NR==4); clus=$(echo $f | tr "_" "\n" | awk NR==5); cl=$(echo $clus | sed 's/.pdbqt//g'); ifreq=0; acpx=; acp=; acpn=1; acpo=; donx=; don=; donn=1; dono=; n=0; num=$(cat xhb.txt | wc -l); for b in $(seq 1 $num); do echo $b; s=$(cat xhb.txt | awk NR==$b | tr " " "\n"); r1=$(echo $s | tr " " "\n"| awk NR==1); res1=$(echo ${r1:6:3}); ch1=$(echo ${r1:0:1}); id1=$(echo ${r1:2:3}); atm1=$(echo $s | tr " " "\n"| awk NR==2); r2=$(echo $s | tr " " "\n"| awk NR==3); res2=$(echo ${r2:6:3}); ch2=$(echo ${r2:0:1}); id2=$(echo ${r2:2:3}); atm2=$(echo $s | tr " " "\n"| awk NR==4); if [ "$ch1" == "X" ] && [ "$ch2" != "X" ]; then acp=$(echo $ch2-$res2-$id2-$atm2-a); let ifreq++; elif [ "$ch2" == "X" ] && [ "$ch1" != "X" ]; then don=$(echo $ch1-$res1-$id1-$atm1-d); let ifreq++; fi; if [ "$acp-$acpn" == "$acpo-$acpn" ]; then let acpn++; elif [ "$acp-$acpn" != "$acpo-$acpn" ]; then acpn=1; fi; if [ "$acpx" == "" ] && [ "$acp" != "" ]; then acpx=$(echo $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" != "$acpo" ]; then acpx=$(echo $acpx "," $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" == "$acpo" ]; then let n=acpn-1; acpx=$(echo $acpx | sed s/"$acp"-"$n"/"$acp"-"$acpn"/g); fi; acpo=$(echo $acp-$acpn); acp=; if [ "$don-$donn" == "$dono-$donn" ]; then let donn++; elif [ "$don-$donn" != "$dono-$donn" ]; then donn=1; fi; if [ "$donx" == "" ] && [ "$don" != "" ]; then donx=$(echo $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" != "$dono" ]; then donx=$(echo $donx "," $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" == "$dono" ]; then let n=donn-1; donx=$(echo $donx | sed s/"$don"-"$n"/"$don"-"$donn"/g); fi; dono=$(echo $don-$donn); don=; done; echo $acpx; echo $donx; echo $ifreq; echo $group "|" $comp "|" $rank "|" $emin "|" $cl "|" $acpx "|" $donx "|" $ifreq >> ../ussimposummary.txt; done; cd ..; cat ussimposummary.txt | sort -k4n -t"|" > ussimposummary-aff.sort; cat ussimposummary.txt | sort -k9nr -t"|" > ussimposummary-lif.sort; done; cd ..; done; cd ..; done

### Analysis of binding interactions ###

case $aanum in
1 )  for a in ???; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
2 )  for a in ???; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
3 )  for a in ???; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
4 )  for a in ???; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
5 )  for a in ???; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4|$aar5" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

### With percentage ###

for a in ???; do echo $a; rm "$name"-"$a"-orisummary.txt; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; l=$(cat orisite-aff.sort | wc -l); e=$(cat orisite-aff.sort | tr "|" "\n" | awk NR==4); r=$(ls *fixed.pdb | wc -l); echo $a"v"$x "|" $e "|" $l "|" $l"/"$r >> ../../"$name"-"$a"-orisummary.txt; cd ..; done; cd ..; done

for a in ???; do echo $a; rm "$name"-"$a"-orisummary-e.sort; cat "$name"-"$a"-orisummary.txt | sort -k2n -k3nr -t"|" >> "$name"-"$a"-orisummary-e.sort; rm "$name"-"$a"-orisummary-p.sort; cat "$name"-"$a"-orisummary.txt | sort -k3nr -k2n -t"|" >> "$name"-"$a"-orisummary-p.sort; done

for a in ???; do echo $a; rm "$name"-"$a"-totalorisummary-e.sort; tl=0; tr=0; for x in {1..5}; do echo $x; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); l=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==3); r=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==4 | tr "/" "\n" | awk NR==2); let tl=tl+l; let tr=tr+r; p=$(bc <<< 'scale=3;'$tl'/'$tr'*100'); echo $a "|" $e "|" $l "|" $l"/"$r "|" $tl "|" $tl"/"$tr "|" $p >> "$name"-"$a"-totalorisummary-e.sort; done; done

### With Max and Min Binding Affinity ###

rm "$name"-all-orisummary.txt; for a in ???; do echo $a; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==1 | tr "|" "\n" | awk NR==2); p=$(cat "$name"-"$a"-totalorisummary-e.sort | awk NR==5 | tr "|" "\n" | awk NR==7); emin=-20.0; for x in {1..5}; do echo $x; ex=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); echo $ex; if [[ '$ex' > '$emin' || $ex == $emin ]] && [ $ex != "" ]; then emin=$ex; echo $emin; else emin=$emin; echo $emin; fi; done; echo $a "|" $e "|" $emin "|" $p >> "$name"-all-orisummary.txt; done; 

### Pre-Summary ###

case $aanum in
1 )  echo "$name > $aar1" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
2 )  echo "$name > $aar1|$aar2" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
3 )  echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
4 )  echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
5 )  echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

cd ..

#### End of l3aa200 peptides analysis ####


#### l3aa200 Summary ####

echo "Top l3aa peptides ranking based on binding affinity (free energy of binding)" > "$name"-l3aa-top200-binding-affinity.txt

echo " " >> "$name"-l3aa-top200-binding-affinity.txt

echo "Top l3aa peptides ranking based on binding percentage" > "$name"-l3aa-top200-binding-percentage.txt

echo " " >> "$name"-l3aa-top200-binding-percentage.txt

cd l3aa200

cat "$name"-all-orisummary-e.sort >> ../"$name"-l3aa-top200-binding-affinity.txt

cat "$name"-all-orisummary-p.sort >> ../"$name"-l3aa-top200-binding-percentage.txt

cd ..

echo " " >> "$name"-l3aa-top200-binding-affinity.txt

echo " " >> "$name"-l3aa-top200-binding-affinity.txt

echo " " >> "$name"-l3aa-top200-binding-percentage.txt

echo " " >> "$name"-l3aa-top200-binding-percentage.txt


#### End of summary ####


fi

#### End of condition ####

#### Record the time ####

echo "l3aa End time: " $(date) >> $name-time.txt

#### End of time recording ####



#### Check for peptide length ####

if [ "$xxx" == 3 ]; then echo "End time: " $(date) >> $name-time.txt; echo; echo "Job finished!"; exit; fi

#### End of checking ####



#### Generating l4aa peptides ####

### Creating folder ###

mkdir l4aa-pgen

for num in {1..20}; do aa3=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aa3; cd l4aa-pgen; mkdir $aa3; cd ..; done

cd l3aa200

### Retrieve top 100 l3aa peptides (need to mkdir ???-pgen first) {2..101} ###

file="$name"-all-orisummary-p.sort

for a in {2..101}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3; for num in {1..20}; do a4=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a4t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a4; echo $a4t; echo $aa3$a4 >> ../l4aa-pgen/$a4t/l3aa-$a4.txt ; done; done

cd ..

cd l4aa-pgen

### Create l4aa peptides using pymol ###

for num in {1..20}; do a4=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a4t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a4; echo $a4t; file=l3aa-$a4.txt; cd $a4t; cp ../../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'4'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done; cd ..; done

### Preparing pdbqt from pdb ###

for num in {1..20}; do a4=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a4t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a4; echo $a4t; cd $a4t; for aa in ????.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done; cd ..; done

cd ..

### Creating docking folders for l4aa ###

mkdir l4aa

for num in {1..20}; do aa3=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aa3; cd l4aa; mkdir $aa3; cd ..; done

cd l4aa-pgen

### Moving l4aa peptides pdbqt to new folder ###

for num in {1..20}; do a4t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a4t; cd $a4t; cp *.pdbqt ../../l4aa/$a4t/; cd ..; done

cd ..

cd l4aa

for a in ???; do echo $a; cd $a; for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done; cd ..; done

cd ..

#### End of l4aa peptides generation and preparation ####


#### Start screening for l4aa peptides ####

cd l4aa

for f in ???; do echo $f; cd $f; for d in ????; do echo $d; cd $d; rm $name.pdbqt conf.txt ; cd ..; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ????; do echo $d; cp ../../$name.pdbqt ../../conf.txt $d/; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ????; do echo $d; cd $d; vina --config conf.txt --ligand "$d".pdbqt --out "$d"_out.pdbqt --log log"$d".txt; cd ..; done; cd ..; done

cd ..

#### End of l4aa peptides screening ####


#### Creating docking backup for l4aa peptides ####

cp -r l4aa/ l4aa-bk

#### End of backup creation ####


#### Start fast l4aa peptides analysis #### ala arg asn asp cys gln glu gly his ile leu lys met phe pro ser thr trp tyr val

cd l4aa

rm "$name"-l4aa-pre.txt; for f in ???; do echo $f; cd $f; for d in ????; do echo $d; cd $d; z=$(grep "0\.000" log"$d".txt); e=$(echo $z | tr " " "\n" | awk NR==2); echo $d "|" $e >> ../../"$name"-l4aa-pre.txt; cd ..; done; cd ..; done

cat "$name"-l4aa-pre.txt | sort -k2n -t"|" > "$name"-l4aa-pre.sort

echo "$name" > "$name"-l4aadb-fsummary-e.sort; cat "$name"-l4aa-pre.sort | sort -k2n -t"|" >> "$name"-l4aadb-fsummary-e.sort; 

cd ..

#### End of fast l4aa peptides analysis ####


#### l4aa Fast Summary ####

echo "l4aa peptides ranking based on binding affinity (free energy of binding)" >> "$name"-l4aa-fast-summary.txt

echo " " >> "$name"-l4aa-fast-summary.txt

cd l4aa

cat "$name"-l4aadb-fsummary-e.sort >> ../"$name"-l4aa-fast-summary.txt

cd ..

echo " " >> "$name"-l4aa-fast-summary.txt

echo " " >> "$name"-l4aa-fast-summary.txt

#### End of summary ####


#### run full hbplus analysis and summary with condition ####

if [[ "$tas" == "y" || "$tas" == "Y" ]] ; then


#### Generating top 200 l4aa peptides ####

### Creating folder ###

mkdir l4aa200-pgen

rm l4aa200.txt

### Retrieve top 200 l4aa peptides (need to mkdir ????-pgen first) {2..201} ###

cd l4aa

file=$name-l4aadb-fsummary-e.sort

for a in {2..201}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3 >> ../l4aa200-pgen/l4aa200.txt ; done

cd ..

### Create top 200 l4aa peptides using pymol ###

cd l4aa200-pgen

file=l4aa200.txt; cp ../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'4'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done

### Preparing pdbqt from pdb ###

for aa in ????.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done

cd ..

### Creating docking folders for l4aa200 ###

mkdir l4aa200

### Moving l4aa200 peptides pdbqt to new folder ###

cd l4aa200-pgen

cp *.pdbqt ../l4aa200/

cd ..

cd l4aa200

for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done

cd ..

#### End of l4aa200 peptides generation and preparation ####


#### Start screening for l4aa200 peptides ####

cd l4aa200

for f in ????; do echo $f; cd $f; rm $name.pdbqt conf.txt ; cd ..; done

for f in ????; do echo $f; cp ../$name.pdbqt ../conf100e.txt $f/; done

for f in ????; do echo $f; cd $f; for d in {1..5}; do echo $d; vina --config conf100e.txt --ligand $f.pdbqt --out "$f"v"$d"_out.pdbqt --log log"$f"v"$d".txt; done; cd ..; done

cd ..

#### End of l4aa200 peptides screening ####


#### Start l4aa200 peptides analysis ####

cd l4aa200

### Create folder and store separately ###

for f in ????; do echo $f; cd $f; for d in {1..5}; do echo $d; mkdir "$f"v"$d"; mv "$f"v"$d"_out.pdbqt log"$f"v"$d".txt "$f"v"$d"/; cp $name.pdbqt "$f"v"$d"/; done; cd ..; done

### Splitting files ###

for f in ????; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; rm -r *-??? *.pdb; for x in *out.pdbqt; do echo $x; csplit -k -s -n 3 -f "$f"v"$d"- $x '%^MODEL%' '/^MODEL/' '{*}'; done; for z in "$f"v"$d"-???; do echo $z; filename="$z".pdb; echo $filename; mv $z $filename; done; cd ..; done; cd ..; done

### Fixing broken peptides ###

for f in ????; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; for x in *-???.pdb; do echo $x; z=`basename $x .pdb`; echo $z; rm $z-fixed.pdb; for a in {1..4}; do echo $a; grep "X   $a" $x >> $z-fixed.pdb; done; done; cd ..; done; cd ..; done

### Preparation for hbplus ###

for z in ????; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for f in *-???.pdb; do echo $f; fd=$(echo $f | sed 's/.pdb//g'); mkdir $fd; cp $f $fd/; cp $fd-fixed.pdb $fd/; cp $name.pdbqt $fd/; cd $fd; num=$(grep MODEL $f); n=$(echo $num | tr " " "\n" | awk NR==2); data=$(grep VINA $f); e=$(echo $data | tr " " "\n" | awk NR==4); r=$(echo $data | tr " " "\n" | awk NR==6); filename="$name"_"$fd"_"$n"_"$e"_"$r"; mv $name.pdbqt $filename.pdbqt; grep ATOM $fd-fixed.pdb > $filename.pdb; grep TER "$f" >> $filename.pdb; sed -i 's/ATOM  /HETATM/g' $filename.pdb; grep HETATM $filename.pdb >> $filename.pdbqt; grep TER $filename.pdb >> $filename.pdbqt; cd ..; done; cd ..; done; cd ..; done

### Running hbplus ###
for z in ????; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for a in *-???; do echo $a; cd $a; $hbd/hbplus -a 75 -d 4.9 -h 4.5 *pdbqt; grep X0 *hb2 > xhb.txt; cd ..; done; cd ..; done; cd ..; done 

#### Analysis of hbplus result ####
for a in ????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; rm ussimposummary.txt; echo "Group | Compound | Rank | Affinity | RMSD | Acceptor | Donor | IF" > ussimposummary.txt; for z in *-???; do echo $z; cd $z; for f in *.pdbqt; do echo $f; group=$(echo $f | tr "_" "\n" | awk NR==1); comp=$(echo $f | tr "_" "\n" | awk NR==2); rank=$(echo $f | tr "_" "\n" | awk NR==3); emin=$(echo $f | tr "_" "\n" | awk NR==4); clus=$(echo $f | tr "_" "\n" | awk NR==5); cl=$(echo $clus | sed 's/.pdbqt//g'); ifreq=0; acpx=; acp=; acpn=1; acpo=; donx=; don=; donn=1; dono=; n=0; num=$(cat xhb.txt | wc -l); for b in $(seq 1 $num); do echo $b; s=$(cat xhb.txt | awk NR==$b | tr " " "\n"); r1=$(echo $s | tr " " "\n"| awk NR==1); res1=$(echo ${r1:6:3}); ch1=$(echo ${r1:0:1}); id1=$(echo ${r1:2:3}); atm1=$(echo $s | tr " " "\n"| awk NR==2); r2=$(echo $s | tr " " "\n"| awk NR==3); res2=$(echo ${r2:6:3}); ch2=$(echo ${r2:0:1}); id2=$(echo ${r2:2:3}); atm2=$(echo $s | tr " " "\n"| awk NR==4); if [ "$ch1" == "X" ] && [ "$ch2" != "X" ]; then acp=$(echo $ch2-$res2-$id2-$atm2-a); let ifreq++; elif [ "$ch2" == "X" ] && [ "$ch1" != "X" ]; then don=$(echo $ch1-$res1-$id1-$atm1-d); let ifreq++; fi; if [ "$acp-$acpn" == "$acpo-$acpn" ]; then let acpn++; elif [ "$acp-$acpn" != "$acpo-$acpn" ]; then acpn=1; fi; if [ "$acpx" == "" ] && [ "$acp" != "" ]; then acpx=$(echo $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" != "$acpo" ]; then acpx=$(echo $acpx "," $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" == "$acpo" ]; then let n=acpn-1; acpx=$(echo $acpx | sed s/"$acp"-"$n"/"$acp"-"$acpn"/g); fi; acpo=$(echo $acp-$acpn); acp=; if [ "$don-$donn" == "$dono-$donn" ]; then let donn++; elif [ "$don-$donn" != "$dono-$donn" ]; then donn=1; fi; if [ "$donx" == "" ] && [ "$don" != "" ]; then donx=$(echo $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" != "$dono" ]; then donx=$(echo $donx "," $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" == "$dono" ]; then let n=donn-1; donx=$(echo $donx | sed s/"$don"-"$n"/"$don"-"$donn"/g); fi; dono=$(echo $don-$donn); don=; done; echo $acpx; echo $donx; echo $ifreq; echo $group "|" $comp "|" $rank "|" $emin "|" $cl "|" $acpx "|" $donx "|" $ifreq >> ../ussimposummary.txt; done; cd ..; cat ussimposummary.txt | sort -k4n -t"|" > ussimposummary-aff.sort; cat ussimposummary.txt | sort -k9nr -t"|" > ussimposummary-lif.sort; done; cd ..; done; cd ..; done

### Analysis of binding interactions ###

case $aanum in
1 )  for a in ????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
2 )  for a in ????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
3 )  for a in ????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
4 )  for a in ????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
5 )  for a in ????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4|$aar5" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

### With percentage ###

for a in ????; do echo $a; rm "$name"-"$a"-orisummary.txt; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; l=$(cat orisite-aff.sort | wc -l); e=$(cat orisite-aff.sort | tr "|" "\n" | awk NR==4); r=$(ls *fixed.pdb | wc -l); echo $a"v"$x "|" $e "|" $l "|" $l"/"$r >> ../../"$name"-"$a"-orisummary.txt; cd ..; done; cd ..; done

for a in ????; do echo $a; rm "$name"-"$a"-orisummary-e.sort; cat "$name"-"$a"-orisummary.txt | sort -k2n -k3nr -t"|" >> "$name"-"$a"-orisummary-e.sort; rm "$name"-"$a"-orisummary-p.sort; cat "$name"-"$a"-orisummary.txt | sort -k3nr -k2n -t"|" >> "$name"-"$a"-orisummary-p.sort; done

for a in ????; do echo $a; rm "$name"-"$a"-totalorisummary-e.sort; tl=0; tr=0; for x in {1..5}; do echo $x; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); l=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==3); r=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==4 | tr "/" "\n" | awk NR==2); let tl=tl+l; let tr=tr+r; p=$(bc <<< 'scale=3;'$tl'/'$tr'*100'); echo $a "|" $e "|" $l "|" $l"/"$r "|" $tl "|" $tl"/"$tr "|" $p >> "$name"-"$a"-totalorisummary-e.sort; done; done

### With Max and Min Binding Affinity ###

rm "$name"-all-orisummary.txt; for a in ????; do echo $a; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==1 | tr "|" "\n" | awk NR==2); p=$(cat "$name"-"$a"-totalorisummary-e.sort | awk NR==5 | tr "|" "\n" | awk NR==7); emin=-20.0; for x in {1..5}; do echo $x; ex=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); echo $ex; if [[ '$ex' > '$emin' || $ex == $emin ]] && [ $ex != "" ]; then emin=$ex; echo $emin; else emin=$emin; echo $emin; fi; done; echo $a "|" $e "|" $emin "|" $p >> "$name"-all-orisummary.txt; done; 

### Pre-Summary ###

case $aanum in
1 )  echo "$name > $aar1" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
2 )  echo "$name > $aar1|$aar2" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
3 )  echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
4 )  echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
5 )  echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

cd ..

#### End of l4aa200 peptides analysis ####


#### l4aa200 Summary ####

echo "Top l4aa peptides ranking based on binding affinity (free energy of binding)" > "$name"-l4aa-top200-binding-affinity.txt

echo " " >> "$name"-l4aa-top200-binding-affinity.txt

echo "Top l4aa peptides ranking based on binding percentage" > "$name"-l4aa-top200-binding-percentage.txt

echo " " >> "$name"-l4aa-top200-binding-percentage.txt

cd l4aa200

cat "$name"-all-orisummary-e.sort >> ../"$name"-l4aa-top200-binding-affinity.txt

cat "$name"-all-orisummary-p.sort >> ../"$name"-l4aa-top200-binding-percentage.txt

cd ..

echo " " >> "$name"-l4aa-top200-binding-affinity.txt

echo " " >> "$name"-l4aa-top200-binding-affinity.txt

echo " " >> "$name"-l4aa-top200-binding-percentage.txt

echo " " >> "$name"-l4aa-top200-binding-percentage.txt


#### End of summary ####


fi

#### End of condition ####


#### Record the time ####

echo "l4aa End time: " $(date) >> $name-time.txt

#### End of time recording ####



#### Check for peptide length ####

if [ "$xxx" == 4 ]; then echo "End time: " $(date) >> $name-time.txt; echo; echo "Job finished!"; exit; fi

#### End of checking ####



#### Generating l5aa peptides ####

### Creating folder ###

mkdir l5aa-pgen

for num in {1..20}; do aax=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aax; cd l5aa-pgen; mkdir $aax; cd ..; done

cd l4aa200

### Retrieve top 100 l4aa peptides (need to mkdir ???-pgen first) {2..101} ###

file="$name"-all-orisummary-p.sort

for a in {2..101}; do echo $a; aax=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aax; for num in {1..20}; do a5=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a5t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a5; echo $a5t; echo $aax$a5 >> ../l5aa-pgen/$a5t/l4aa-$a5.txt ; done; done

cd ..

cd l5aa-pgen

### Create l5aa peptides using pymol ###

for num in {1..20}; do a5=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a5t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a5; echo $a5t; file=l4aa-$a5.txt; cd $a5t; cp ../../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'5'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done; cd ..; done

### Preparing pdbqt from pdb ###

for num in {1..20}; do a5=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a5t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a5; echo $a5t; cd $a5t; for aa in ?????.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done; cd ..; done

cd ..

### Creating docking folders for l5aa ###

mkdir l5aa

for num in {1..20}; do aax=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aax; cd l5aa; mkdir $aax; cd ..; done

cd l5aa-pgen

### Moving l5aa peptides pdbqt to new folder ###

for num in {1..20}; do a5t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a5t; cd $a5t; cp *.pdbqt ../../l5aa/$a5t/; cd ..; done

cd ..

cd l5aa

for a in ???; do echo $a; cd $a; for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done; cd ..; done

cd ..

#### End of l5aa peptides generation and preparation ####


#### Start screening for l5aa peptides ####

cd l5aa

for f in ???; do echo $f; cd $f; for d in ?????; do echo $d; cd $d; rm $name.pdbqt conf.txt ; cd ..; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ?????; do echo $d; cp ../../$name.pdbqt ../../conf.txt $d/; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ?????; do echo $d; cd $d; vina --config conf.txt --ligand "$d".pdbqt --out "$d"_out.pdbqt --log log"$d".txt; cd ..; done; cd ..; done

cd ..

#### End of l5aa peptides screening ####


#### Creating docking backup for l5aa peptides ####

cp -r l5aa/ l5aa-bk

#### End of backup creation ####


#### Start fast l5aa peptides analysis ####

cd l5aa

rm "$name"-l5aa-pre.txt; for f in ???; do echo $f; cd $f; for d in ?????; do echo $d; cd $d; z=$(grep "0\.000" log"$d".txt); e=$(echo $z | tr " " "\n" | awk NR==2); echo $d "|" $e >> ../../"$name"-l5aa-pre.txt; cd ..; done; cd ..; done

cat "$name"-l5aa-pre.txt | sort -k2n -t"|" > "$name"-l5aa-pre.sort

echo "$name" > "$name"-l5aadb-fsummary-e.sort; cat "$name"-l5aa-pre.sort | sort -k2n -t"|" >> "$name"-l5aadb-fsummary-e.sort; 

cd ..

#### End of fast l5aa peptides analysis ####


#### l5aa Fast Summary ####

echo "l5aa peptides ranking based on binding affinity (free energy of binding)" >> "$name"-l5aa-fast-summary.txt

echo " " >> "$name"-l5aa-fast-summary.txt

cd l5aa

cat "$name"-l5aadb-fsummary-e.sort >> ../"$name"-l5aa-fast-summary.txt

cd ..

echo " " >> "$name"-l5aa-fast-summary.txt

echo " " >> "$name"-l5aa-fast-summary.txt

#### End of summary ####


#### run full hbplus analysis and summary with condition ####

if [[ "$tas" == "y" || "$tas" == "Y" ]] ; then


#### Generating top 200 l5aa peptides ####

### Creating folder ###

mkdir l5aa200-pgen

rm l5aa200.txt

### Retrieve top 200 l5aa peptides (need to mkdir ?????-pgen first) {2..201} ###

cd l5aa

file=$name-l5aadb-fsummary-e.sort

for a in {2..201}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3 >> ../l5aa200-pgen/l5aa200.txt ; done

cd ..

### Create top 200 l5aa peptides using pymol ###

cd l5aa200-pgen

file=l5aa200.txt; cp ../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'5'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done

### Preparing pdbqt from pdb ###

for aa in ?????.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done

cd ..

### Creating docking folders for l5aa200 ###

mkdir l5aa200

### Moving l5aa200 peptides pdbqt to new folder ###

cd l5aa200-pgen

cp *.pdbqt ../l5aa200/

cd ..

cd l5aa200

for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done

cd ..

#### End of l5aa200 peptides generation and preparation ####


#### Start screening for l5aa200 peptides ####

cd l5aa200

for f in ?????; do echo $f; cd $f; rm $name.pdbqt conf.txt ; cd ..; done

for f in ?????; do echo $f; cp ../$name.pdbqt ../conf100e.txt $f/; done

for f in ?????; do echo $f; cd $f; for d in {1..5}; do echo $d; vina --config conf100e.txt --ligand $f.pdbqt --out "$f"v"$d"_out.pdbqt --log log"$f"v"$d".txt; done; cd ..; done

cd ..

#### End of l5aa200 peptides screening ####


#### Start l5aa200 peptides analysis ####

cd l5aa200

### Create folder and store separately ###

for f in ?????; do echo $f; cd $f; for d in {1..5}; do echo $d; mkdir "$f"v"$d"; mv "$f"v"$d"_out.pdbqt log"$f"v"$d".txt "$f"v"$d"/; cp $name.pdbqt "$f"v"$d"/; done; cd ..; done

### Splitting files ###

for f in ?????; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; rm -r *-??? *.pdb; for x in *out.pdbqt; do echo $x; csplit -k -s -n 3 -f "$f"v"$d"- $x '%^MODEL%' '/^MODEL/' '{*}'; done; for z in "$f"v"$d"-???; do echo $z; filename="$z".pdb; echo $filename; mv $z $filename; done; cd ..; done; cd ..; done

### Fixing broken peptides ###

for f in ?????; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; for x in *-???.pdb; do echo $x; z=`basename $x .pdb`; echo $z; rm $z-fixed.pdb; for a in {1..5}; do echo $a; grep "X   $a" $x >> $z-fixed.pdb; done; done; cd ..; done; cd ..; done

### Preparation for hbplus ###

for z in ?????; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for f in *-???.pdb; do echo $f; fd=$(echo $f | sed 's/.pdb//g'); mkdir $fd; cp $f $fd/; cp $fd-fixed.pdb $fd/; cp $name.pdbqt $fd/; cd $fd; num=$(grep MODEL $f); n=$(echo $num | tr " " "\n" | awk NR==2); data=$(grep VINA $f); e=$(echo $data | tr " " "\n" | awk NR==4); r=$(echo $data | tr " " "\n" | awk NR==6); filename="$name"_"$fd"_"$n"_"$e"_"$r"; mv $name.pdbqt $filename.pdbqt; grep ATOM $fd-fixed.pdb > $filename.pdb; grep TER "$f" >> $filename.pdb; sed -i 's/ATOM  /HETATM/g' $filename.pdb; grep HETATM $filename.pdb >> $filename.pdbqt; grep TER $filename.pdb >> $filename.pdbqt; cd ..; done; cd ..; done; cd ..; done

### Running hbplus ###
for z in ?????; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for a in *-???; do echo $a; cd $a; $hbd/hbplus -a 75 -d 4.9 -h 4.5 *pdbqt; grep X0 *hb2 > xhb.txt; cd ..; done; cd ..; done; cd ..; done 

#### Analysis of hbplus result ####
for a in ?????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; rm ussimposummary.txt; echo "Group | Compound | Rank | Affinity | RMSD | Acceptor | Donor | IF" > ussimposummary.txt; for z in *-???; do echo $z; cd $z; for f in *.pdbqt; do echo $f; group=$(echo $f | tr "_" "\n" | awk NR==1); comp=$(echo $f | tr "_" "\n" | awk NR==2); rank=$(echo $f | tr "_" "\n" | awk NR==3); emin=$(echo $f | tr "_" "\n" | awk NR==4); clus=$(echo $f | tr "_" "\n" | awk NR==5); cl=$(echo $clus | sed 's/.pdbqt//g'); ifreq=0; acpx=; acp=; acpn=1; acpo=; donx=; don=; donn=1; dono=; n=0; num=$(cat xhb.txt | wc -l); for b in $(seq 1 $num); do echo $b; s=$(cat xhb.txt | awk NR==$b | tr " " "\n"); r1=$(echo $s | tr " " "\n"| awk NR==1); res1=$(echo ${r1:6:3}); ch1=$(echo ${r1:0:1}); id1=$(echo ${r1:2:3}); atm1=$(echo $s | tr " " "\n"| awk NR==2); r2=$(echo $s | tr " " "\n"| awk NR==3); res2=$(echo ${r2:6:3}); ch2=$(echo ${r2:0:1}); id2=$(echo ${r2:2:3}); atm2=$(echo $s | tr " " "\n"| awk NR==4); if [ "$ch1" == "X" ] && [ "$ch2" != "X" ]; then acp=$(echo $ch2-$res2-$id2-$atm2-a); let ifreq++; elif [ "$ch2" == "X" ] && [ "$ch1" != "X" ]; then don=$(echo $ch1-$res1-$id1-$atm1-d); let ifreq++; fi; if [ "$acp-$acpn" == "$acpo-$acpn" ]; then let acpn++; elif [ "$acp-$acpn" != "$acpo-$acpn" ]; then acpn=1; fi; if [ "$acpx" == "" ] && [ "$acp" != "" ]; then acpx=$(echo $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" != "$acpo" ]; then acpx=$(echo $acpx "," $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" == "$acpo" ]; then let n=acpn-1; acpx=$(echo $acpx | sed s/"$acp"-"$n"/"$acp"-"$acpn"/g); fi; acpo=$(echo $acp-$acpn); acp=; if [ "$don-$donn" == "$dono-$donn" ]; then let donn++; elif [ "$don-$donn" != "$dono-$donn" ]; then donn=1; fi; if [ "$donx" == "" ] && [ "$don" != "" ]; then donx=$(echo $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" != "$dono" ]; then donx=$(echo $donx "," $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" == "$dono" ]; then let n=donn-1; donx=$(echo $donx | sed s/"$don"-"$n"/"$don"-"$donn"/g); fi; dono=$(echo $don-$donn); don=; done; echo $acpx; echo $donx; echo $ifreq; echo $group "|" $comp "|" $rank "|" $emin "|" $cl "|" $acpx "|" $donx "|" $ifreq >> ../ussimposummary.txt; done; cd ..; cat ussimposummary.txt | sort -k4n -t"|" > ussimposummary-aff.sort; cat ussimposummary.txt | sort -k9nr -t"|" > ussimposummary-lif.sort; done; cd ..; done; cd ..; done

### Analysis of binding interactions ###

case $aanum in
1 )  for a in ?????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
2 )  for a in ?????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
3 )  for a in ?????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
4 )  for a in ?????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
5 )  for a in ?????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4|$aar5" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

### With percentage ###

for a in ?????; do echo $a; rm "$name"-"$a"-orisummary.txt; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; l=$(cat orisite-aff.sort | wc -l); e=$(cat orisite-aff.sort | tr "|" "\n" | awk NR==4); r=$(ls *fixed.pdb | wc -l); echo $a"v"$x "|" $e "|" $l "|" $l"/"$r >> ../../"$name"-"$a"-orisummary.txt; cd ..; done; cd ..; done

for a in ?????; do echo $a; rm "$name"-"$a"-orisummary-e.sort; cat "$name"-"$a"-orisummary.txt | sort -k2n -k3nr -t"|" >> "$name"-"$a"-orisummary-e.sort; rm "$name"-"$a"-orisummary-p.sort; cat "$name"-"$a"-orisummary.txt | sort -k3nr -k2n -t"|" >> "$name"-"$a"-orisummary-p.sort; done

for a in ?????; do echo $a; rm "$name"-"$a"-totalorisummary-e.sort; tl=0; tr=0; for x in {1..5}; do echo $x; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); l=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==3); r=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==4 | tr "/" "\n" | awk NR==2); let tl=tl+l; let tr=tr+r; p=$(bc <<< 'scale=3;'$tl'/'$tr'*100'); echo $a "|" $e "|" $l "|" $l"/"$r "|" $tl "|" $tl"/"$tr "|" $p >> "$name"-"$a"-totalorisummary-e.sort; done; done

### With Max and Min Binding Affinity ###

rm "$name"-all-orisummary.txt; for a in ?????; do echo $a; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==1 | tr "|" "\n" | awk NR==2); p=$(cat "$name"-"$a"-totalorisummary-e.sort | awk NR==5 | tr "|" "\n" | awk NR==7); emin=-20.0; for x in {1..5}; do echo $x; ex=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); echo $ex; if [[ '$ex' > '$emin' || $ex == $emin ]] && [ $ex != "" ]; then emin=$ex; echo $emin; else emin=$emin; echo $emin; fi; done; echo $a "|" $e "|" $emin "|" $p >> "$name"-all-orisummary.txt; done; 

### Pre-Summary ###

case $aanum in
1 )  echo "$name > $aar1" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
2 )  echo "$name > $aar1|$aar2" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
3 )  echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
4 )  echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
5 )  echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

cd ..

#### End of l5aa200 peptides analysis ####


#### l5aa200 Summary ####

echo "Top l5aa peptides ranking based on binding affinity (free energy of binding)" > "$name"-l5aa-top200-binding-affinity.txt

echo " " >> "$name"-l5aa-top200-binding-affinity.txt

echo "Top l5aa peptides ranking based on binding percentage" > "$name"-l5aa-top200-binding-percentage.txt

echo " " >> "$name"-l5aa-top200-binding-percentage.txt

cd l5aa200

cat "$name"-all-orisummary-e.sort >> ../"$name"-l5aa-top200-binding-affinity.txt

cat "$name"-all-orisummary-p.sort >> ../"$name"-l5aa-top200-binding-percentage.txt

cd ..

echo " " >> "$name"-l5aa-top200-binding-affinity.txt

echo " " >> "$name"-l5aa-top200-binding-affinity.txt

echo " " >> "$name"-l5aa-top200-binding-percentage.txt

echo " " >> "$name"-l5aa-top200-binding-percentage.txt


#### End of summary ####


fi

#### End of condition ####


#### Record the time ####

echo "l5aa End time: " $(date) >> $name-time.txt

#### End of time recording ####



#### Check for peptide length ####

if [ "$xxx" == 5 ]; then echo "End time: " $(date) >> $name-time.txt; echo; echo "Job finished!"; exit; fi

#### End of checking ####



#### Generating l6aa peptides ####

### Creating folder ###

mkdir l6aa-pgen

for num in {1..20}; do aax=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aax; cd l6aa-pgen; mkdir $aax; cd ..; done

cd l5aa200

### Retrieve top 100 l5aa peptides (need to mkdir ???-pgen first) {2..101} ###

file="$name"-all-orisummary-p.sort

for a in {2..101}; do echo $a; aax=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aax; for num in {1..20}; do a6=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a6t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a6; echo $a6t; echo $aax$a6 >> ../l6aa-pgen/$a6t/l5aa-$a6.txt ; done; done

cd ..

cd l6aa-pgen

### Create l6aa peptides using pymol ###

for num in {1..20}; do a6=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a6t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a6; echo $a6t; file=l5aa-$a6.txt; cd $a6t; cp ../../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'6'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done; cd ..; done

### Preparing pdbqt from pdb ###

for num in {1..20}; do a6=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==2); a6t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a6; echo $a6t; cd $a6t; for aa in ??????.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done; cd ..; done

cd ..

### Creating docking folders for l6aa ###

mkdir l6aa

for num in {1..20}; do aax=$(cat aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $aax; cd l6aa; mkdir $aax; cd ..; done

cd l6aa-pgen

### Moving l6aa peptides pdbqt to new folder ###

for num in {1..20}; do a6t=$(cat ../aalist | awk NR==$num | tr "|" "\n"| awk NR==3); echo $a6t; cd $a6t; cp *.pdbqt ../../l6aa/$a6t/; cd ..; done

cd ..

cd l6aa

for a in ???; do echo $a; cd $a; for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done; cd ..; done

cd ..

#### End of l6aa peptides generation and preparation ####


#### Start screening for l6aa peptides ####

cd l6aa

for f in ???; do echo $f; cd $f; for d in ??????; do echo $d; cd $d; rm $name.pdbqt conf.txt ; cd ..; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ??????; do echo $d; cp ../../$name.pdbqt ../../conf.txt $d/; done; cd ..; done

for f in ???; do echo $f; cd $f; for d in ??????; do echo $d; cd $d; vina --config conf.txt --ligand "$d".pdbqt --out "$d"_out.pdbqt --log log"$d".txt; cd ..; done; cd ..; done

cd ..

#### End of l6aa peptides screening ####


#### Creating docking backup for l6aa peptides ####

cp -r l6aa/ l6aa-bk

#### End of backup creation ####


#### Start fast l6aa peptides analysis ####

cd l6aa

rm "$name"-l6aa-pre.txt; for f in ???; do echo $f; cd $f; for d in ??????; do echo $d; cd $d; z=$(grep "0\.000" log"$d".txt); e=$(echo $z | tr " " "\n" | awk NR==2); echo $d "|" $e >> ../../"$name"-l6aa-pre.txt; cd ..; done; cd ..; done

cat "$name"-l6aa-pre.txt | sort -k2n -t"|" > "$name"-l6aa-pre.sort

echo "$name" > "$name"-l6aadb-fsummary-e.sort; cat "$name"-l6aa-pre.sort | sort -k2n -t"|" >> "$name"-l6aadb-fsummary-e.sort; 

cd ..

#### End of fast l6aa peptides analysis ####


#### l6aa Fast Summary ####

echo "l6aa peptides ranking based on binding affinity (free energy of binding)" >> "$name"-l6aa-fast-summary.txt

echo " " >> "$name"-l6aa-fast-summary.txt

cd l6aa

cat "$name"-l6aadb-fsummary-e.sort >> ../"$name"-l6aa-fast-summary.txt

cd ..

echo " " >> "$name"-l6aa-fast-summary.txt

echo " " >> "$name"-l6aa-fast-summary.txt

#### End of summary ####


#### run full hbplus analysis and summary with condition ####

if [[ "$tas" == "y" || "$tas" == "Y" ]] ; then

#### Generating top 200 l6aa peptides ####

### Creating folder ###

mkdir l6aa200-pgen

rm l6aa200.txt

### Retrieve top 200 l6aa peptides (need to mkdir ??????-pgen first) {2..201} ###

cd l6aa

file=$name-l6aadb-fsummary-e.sort

for a in {2..201}; do echo $a; aa3=$(cat $file | awk NR==$a | tr " " "\n"| awk NR==1); echo $aa3 >> ../l6aa200-pgen/l6aa200.txt ; done

cd ..

### Create top 200 l6aa peptides using pymol ###

cd l6aa200-pgen

file=l6aa200.txt; cp ../amac.py amac.py; num=$(cat $file | wc -l); for n in $(seq 1 $num); do echo $n; aa=$(cat $file | awk NR==$n); echo $aa; cp amac.py $aa.py; sed -i 's/??/'$aa'/g' $aa.py; sed -i 's/%/'6'/g' $aa.py; pymol -qc $aa.py; mv $aa.pdb l$aa.pdb; obminimize -opdb -n 100 l$aa.pdb > $aa.pdb; done

### Preparing pdbqt from pdb ###

for aa in ??????.pdb; do $mgld/bin/pythonsh $mgld/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $aa; done

cd ..

### Creating docking folders for l6aa200 ###

mkdir l6aa200

### Moving l6aa200 peptides pdbqt to new folder ###

cd l6aa200-pgen

cp *.pdbqt ../l6aa200/

cd ..

cd l6aa200

for d in *pdbqt; do echo $d; k=`basename $d .pdbqt`; echo $k; mkdir $k; mv $d $k/; done

cd ..

#### End of l6aa200 peptides generation and preparation ####


#### Start screening for l6aa100 peptides ####

cd l6aa200

for f in ??????; do echo $f; cd $f; rm $name.pdbqt conf.txt ; cd ..; done

for f in ??????; do echo $f; cp ../$name.pdbqt ../conf100e.txt $f/; done

for f in ??????; do echo $f; cd $f; for d in {1..5}; do echo $d; vina --config conf100e.txt --ligand $f.pdbqt --out "$f"v"$d"_out.pdbqt --log log"$f"v"$d".txt; done; cd ..; done

cd ..

#### End of l6aa200 peptides screening ####


#### Start l6aa200 peptides analysis ####

cd l6aa200

### Create folder and store separately ###

for f in ??????; do echo $f; cd $f; for d in {1..5}; do echo $d; mkdir "$f"v"$d"; mv "$f"v"$d"_out.pdbqt log"$f"v"$d".txt "$f"v"$d"/; cp $name.pdbqt "$f"v"$d"/; done; cd ..; done

### Splitting files ###

for f in ??????; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; rm -r *-??? *.pdb; for x in *out.pdbqt; do echo $x; csplit -k -s -n 3 -f "$f"v"$d"- $x '%^MODEL%' '/^MODEL/' '{*}'; done; for z in "$f"v"$d"-???; do echo $z; filename="$z".pdb; echo $filename; mv $z $filename; done; cd ..; done; cd ..; done

### Fixing broken peptides ###

for f in ??????; do echo $f; cd $f; for d in {1..5}; do echo "$f"v"$d"; cd "$f"v"$d"; for x in *-???.pdb; do echo $x; z=`basename $x .pdb`; echo $z; rm $z-fixed.pdb; for a in {1..6}; do echo $a; grep "X   $a" $x >> $z-fixed.pdb; done; done; cd ..; done; cd ..; done

### Preparation for hbplus ###

for z in ??????; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for f in *-???.pdb; do echo $f; fd=$(echo $f | sed 's/.pdb//g'); mkdir $fd; cp $f $fd/; cp $fd-fixed.pdb $fd/; cp $name.pdbqt $fd/; cd $fd; num=$(grep MODEL $f); n=$(echo $num | tr " " "\n" | awk NR==2); data=$(grep VINA $f); e=$(echo $data | tr " " "\n" | awk NR==4); r=$(echo $data | tr " " "\n" | awk NR==6); filename="$name"_"$fd"_"$n"_"$e"_"$r"; mv $name.pdbqt $filename.pdbqt; grep ATOM $fd-fixed.pdb > $filename.pdb; grep TER "$f" >> $filename.pdb; sed -i 's/ATOM  /HETATM/g' $filename.pdb; grep HETATM $filename.pdb >> $filename.pdbqt; grep TER $filename.pdb >> $filename.pdbqt; cd ..; done; cd ..; done; cd ..; done

### Running hbplus ###
for z in ??????; do echo $z; cd $z; for d in {1..5}; do echo "$z"v"$d"; cd "$z"v"$d"; for a in *-???; do echo $a; cd $a; $hbd/hbplus -a 75 -d 4.9 -h 4.5 *pdbqt; grep X0 *hb2 > xhb.txt; cd ..; done; cd ..; done; cd ..; done 

#### Analysis of hbplus result ####
for a in ??????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; rm ussimposummary.txt; echo "Group | Compound | Rank | Affinity | RMSD | Acceptor | Donor | IF" > ussimposummary.txt; for z in *-???; do echo $z; cd $z; for f in *.pdbqt; do echo $f; group=$(echo $f | tr "_" "\n" | awk NR==1); comp=$(echo $f | tr "_" "\n" | awk NR==2); rank=$(echo $f | tr "_" "\n" | awk NR==3); emin=$(echo $f | tr "_" "\n" | awk NR==4); clus=$(echo $f | tr "_" "\n" | awk NR==5); cl=$(echo $clus | sed 's/.pdbqt//g'); ifreq=0; acpx=; acp=; acpn=1; acpo=; donx=; don=; donn=1; dono=; n=0; num=$(cat xhb.txt | wc -l); for b in $(seq 1 $num); do echo $b; s=$(cat xhb.txt | awk NR==$b | tr " " "\n"); r1=$(echo $s | tr " " "\n"| awk NR==1); res1=$(echo ${r1:6:3}); ch1=$(echo ${r1:0:1}); id1=$(echo ${r1:2:3}); atm1=$(echo $s | tr " " "\n"| awk NR==2); r2=$(echo $s | tr " " "\n"| awk NR==3); res2=$(echo ${r2:6:3}); ch2=$(echo ${r2:0:1}); id2=$(echo ${r2:2:3}); atm2=$(echo $s | tr " " "\n"| awk NR==4); if [ "$ch1" == "X" ] && [ "$ch2" != "X" ]; then acp=$(echo $ch2-$res2-$id2-$atm2-a); let ifreq++; elif [ "$ch2" == "X" ] && [ "$ch1" != "X" ]; then don=$(echo $ch1-$res1-$id1-$atm1-d); let ifreq++; fi; if [ "$acp-$acpn" == "$acpo-$acpn" ]; then let acpn++; elif [ "$acp-$acpn" != "$acpo-$acpn" ]; then acpn=1; fi; if [ "$acpx" == "" ] && [ "$acp" != "" ]; then acpx=$(echo $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" != "$acpo" ]; then acpx=$(echo $acpx "," $acp-$acpn); elif [ "$acpx" != "" ] && [ "$acp" != "" ] && [ "$acp" == "$acpo" ]; then let n=acpn-1; acpx=$(echo $acpx | sed s/"$acp"-"$n"/"$acp"-"$acpn"/g); fi; acpo=$(echo $acp-$acpn); acp=; if [ "$don-$donn" == "$dono-$donn" ]; then let donn++; elif [ "$don-$donn" != "$dono-$donn" ]; then donn=1; fi; if [ "$donx" == "" ] && [ "$don" != "" ]; then donx=$(echo $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" != "$dono" ]; then donx=$(echo $donx "," $don-$donn); elif [ "$donx" != "" ] && [ "$don" != "" ] && [ "$don" == "$dono" ]; then let n=donn-1; donx=$(echo $donx | sed s/"$don"-"$n"/"$don"-"$donn"/g); fi; dono=$(echo $don-$donn); don=; done; echo $acpx; echo $donx; echo $ifreq; echo $group "|" $comp "|" $rank "|" $emin "|" $cl "|" $acpx "|" $donx "|" $ifreq >> ../ussimposummary.txt; done; cd ..; cat ussimposummary.txt | sort -k4n -t"|" > ussimposummary-aff.sort; cat ussimposummary.txt | sort -k9nr -t"|" > ussimposummary-lif.sort; done; cd ..; done; cd ..; done

### Analysis of binding interactions ###

case $aanum in
1 )  for a in ??????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
2 )  for a in ??????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
3 )  for a in ??????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
4 )  for a in ??????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
5 )  for a in ??????; do echo $a; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; cat ussimposummary-aff.sort | egrep "$aar1|$aar2|$aar3|$aar4|$aar5" > orisite.txt; cat orisite.txt | sort -k4n -t"|" > orisite-aff.sort; cd ..; done; cd ..; done ;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

### With percentage ###

for a in ??????; do echo $a; rm "$name"-"$a"-orisummary.txt; cd $a; for x in {1..5}; do echo "$a"v"$x"; cd "$a"v"$x"; l=$(cat orisite-aff.sort | wc -l); e=$(cat orisite-aff.sort | tr "|" "\n" | awk NR==4); r=$(ls *fixed.pdb | wc -l); echo $a"v"$x "|" $e "|" $l "|" $l"/"$r >> ../../"$name"-"$a"-orisummary.txt; cd ..; done; cd ..; done

for a in ??????; do echo $a; rm "$name"-"$a"-orisummary-e.sort; cat "$name"-"$a"-orisummary.txt | sort -k2n -k3nr -t"|" >> "$name"-"$a"-orisummary-e.sort; rm "$name"-"$a"-orisummary-p.sort; cat "$name"-"$a"-orisummary.txt | sort -k3nr -k2n -t"|" >> "$name"-"$a"-orisummary-p.sort; done

for a in ??????; do echo $a; rm "$name"-"$a"-totalorisummary-e.sort; tl=0; tr=0; for x in {1..5}; do echo $x; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); l=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==3); r=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==4 | tr "/" "\n" | awk NR==2); let tl=tl+l; let tr=tr+r; p=$(bc <<< 'scale=3;'$tl'/'$tr'*100'); echo $a "|" $e "|" $l "|" $l"/"$r "|" $tl "|" $tl"/"$tr "|" $p >> "$name"-"$a"-totalorisummary-e.sort; done; done

### With Max and Min Binding Affinity ###

rm "$name"-all-orisummary.txt; for a in ??????; do echo $a; e=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==1 | tr "|" "\n" | awk NR==2); p=$(cat "$name"-"$a"-totalorisummary-e.sort | awk NR==5 | tr "|" "\n" | awk NR==7); emin=-20.0; for x in {1..5}; do echo $x; ex=$(cat "$name"-"$a"-orisummary-e.sort | awk NR==$x | tr "|" "\n" | awk NR==2); echo $ex; if [[ '$ex' > '$emin' || $ex == $emin ]] && [ $ex != "" ]; then emin=$ex; echo $emin; else emin=$emin; echo $emin; fi; done; echo $a "|" $e "|" $emin "|" $p >> "$name"-all-orisummary.txt; done; 

### Pre-Summary ###

case $aanum in
1 )  echo "$name > $aar1" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
2 )  echo "$name > $aar1|$aar2" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
3 )  echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
4 )  echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
5 )  echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-e.sort; cat "$name"-all-orisummary.txt | sort -k2n -k4nr -t"|" >> "$name"-all-orisummary-e.sort; echo "$name > $aar1|$aar2|$aar3|$aar4|$aar5" > "$name"-all-orisummary-p.sort; cat "$name"-all-orisummary.txt | sort -k4nr -k2n -t"|" >> "$name"-all-orisummary-p.sort;;
* ) echo "Please enter 1, 2, 3, 4 or 5 only for number of amino acid residues in binding site.." ;;
esac

cd ..

#### End of l6aa200 peptides analysis ####


#### l6aa200 Summary ####

echo "Top l6aa peptides ranking based on binding affinity (free energy of binding)" > "$name"-l6aa-top200-binding-affinity.txt

echo " " >> "$name"-l6aa-top200-binding-affinity.txt

echo "Top l6aa peptides ranking based on binding percentage" > "$name"-l6aa-top200-binding-percentage.txt

echo " " >> "$name"-l6aa-top200-binding-percentage.txt

cd l6aa100

cat "$name"-all-orisummary-e.sort >> ../"$name"-l6aa-top200-binding-affinity.txt

cat "$name"-all-orisummary-p.sort >> ../"$name"-l6aa-top200-binding-percentage.txt

cd ..

echo " " >> "$name"-l6aa-top200-binding-affinity.txt

echo " " >> "$name"-l6aa-top200-binding-affinity.txt

echo " " >> "$name"-l6aa-top200-binding-percentage.txt

echo " " >> "$name"-l6aa-top200-binding-percentage.txt


#### End of summary ####

fi

#### End of condition ####

#### Record the time ####

echo "l6aa End time: " $(date) >> $name-time.txt

#### End of time recording ####



#### Check for peptide length ####

if [ "$xxx" == 6 ]; then echo "End time: " $(date) >> $name-time.txt; echo; echo "Job finished!"; exit; fi

#### End of checking ####



#### End of SEP ####
