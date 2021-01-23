#!/bin/sh

. /usr/local/xmmsas_20160201_1833/setsas.sh 
echo $SAS_DIR
echo $SAS_PATH



/usr/local/bin/python /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/srcls.py
/usr/local/bin/python /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/chandra_sr.py


for i in 0203360101 0203360201 0203360301 0203360401 0203360501 0203360601 0203360701 0203360801 0203360901 0203361001 0203361101 0203361201 0203361301 0203361401 0203361501 0203361601 0203361701 0203361801 0203361901 0203362001 0203362101 0203362201 0203362301 0203362401 0203362501 0302350101 0302350201 0302350301 0302350401 0302350501 0302350601 0302350701 0302350801 0302350901 0302351001 0302351101 0302351201 0302351301 0302351401 0302351501 0302351601 0302351701 0302351801 0302351901 0302352001 0302352201 0302352301 0302352401 0302352501 0302353001 0302353101 0302353201 0302353301 0302353401 0501170101 0501170201
do
echo "working on" $i
cd /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
SAS_ODF=/raid2/dxb/xmm/analysis/COSMOS/sicong/$i/ODF; export SAS_ODF
SAS_CCFPATH=/raid2/dxb/xmm/analysis/COSMOS/sicong/ccf; export SAS_CCFPATH
SAS_CCF=/raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis/ccf.cif; export SAS_CCF

cp /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/make_bkg_region_sky_cos.py  /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
cp /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/make_bkg_region_withradec_cos.py /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
cp /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/append_bkg_region.py /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis

/usr/local/bin/python make_bkg_region_sky_cos.py
/usr/local/bin/python make_bkg_region_withradec_cos.py
conv_reg mode=1 inputfile=pnS005-bkg_region-radec.fits outputfile=pnS005-bkg_region-det.fits imagefile=pnS005-obj-image-sky.fits
conv_reg mode=1 inputfile=pnS005-bkg_region-radec.fits outputfile=pnS005-bkg_region-det.fits imagefile=pnS005-obj-image-sky.fits >& ../logs/$i-pnregion.log
#conv_reg mode=1 inputfile=mos1S003-bkg_region-radec.fits outputfile=mos1S003-bkg_region-det.fits imagefile=mos1S003-obj-image-sky.fits
#conv_reg mode=1 inputfile=mos1S003-bkg_region-radec.fits outputfile=mos1S003-bkg_region-det.fits imagefile=mos1S003-obj-image-sky.fits >& ../logs/$i-mos1region.log
#conv_reg mode=1 inputfile=mos2S004-bkg_region-radec.fits outputfile=mos2S004-bkg_region-det.fits imagefile=mos2S004-obj-image-sky.fits
#conv_reg mode=1 inputfile=mos2S004-bkg_region-radec.fits outputfile=mos2S004-bkg_region-det.fits imagefile=mos2S004-obj-image-sky.fits >& ../logs/$i-mos2region.log
#/usr/local/bin/python change_radius.py
#
mv pnS005-bkg_region-sky.fits pnS005-bkg_region-sky-new.fits
mv pnS005-bkg_region-det.fits pnS005-bkg_region-det-new.fits
#mv mos1S003-bkg_region-sky.fits mos1S003-bkg_region-sky-new.fits
#mv mos1S003-bkg_region-det.fits mos1S003-bkg_region-det-new.fits
#mv mos2S004-bkg_region-sky.fits mos2S004-bkg_region-sky-new.fits
#mv mos2S004-bkg_region-det.fits mos2S004-bkg_region-det-new.fits
/usr/local/bin/python append_bkg_region.py

#conv_reg mode=2 inputfile=poly_input.reg outputfile=poly_output.reg imagefile=pnS005-obj-image-sky.fits >& ../logs/$i-polyregion.log
#/usr/local/bin/python chandra_reg.py
# Extract spectra
# Remember to select the ccd that needs to be excluded
#
#fl_spec="0"
fl_spec="1"
if [ "$fl_spec" == 1 ]; then
    echo "Extracting spectra"
    echo "mos-spectra prefix=1S003 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS  mask=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/"$i"-mos1_spectra.log"
    mos-spectra prefix=1S003 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS  mask=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/$i-mos1_spectra.log
    echo "mos-spectra prefix=2S004 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS  mask=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/"$i"-mos2_spectra.log"
    mos-spectra prefix=2S004 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS  mask=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/$i-mos2_spectra.log
    echo "pn-spectra prefix=S005 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS  mask=1 elow=400 ehigh=7200 quad1=1 quad2=1 quad3=1 quad4=1 >& ../logs/"$i"-pn_spectra.log"
    pn-spectra prefix=S005 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS  mask=1 elow=400 ehigh=7200 quad1=1 quad2=1 quad3=1 quad4=1 >& ../logs/$i-pn_spectra.log
    echo "end spectra.."  $i
#
else
    echo "no spectra requested"
fi
#
# Compute particle background
#
#fl_nxb="0"
fl_nxb="1"
if [ "$fl_nxb" == 1 ]; then
    echo "Particle background"
    rm *back.pi 

    echo "mos_back prefix=1S003 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS/ diag=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/"$i"-mos1_bkg.log"
    mos_back prefix=1S003 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS/ diag=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=0 ccd7=1 >& ../logs/$i-mos1_bkg.log
    echo "mos_back prefix=2S004 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS/ diag=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/"$i"-mos2_bkg.log"
    mos_back prefix=2S004 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS/ diag=0 elow=400 ehigh=7200 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 >& ../logs/$i-mos2_bkg.log
    echo "pn_back prefix=S005 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS/ diag=0 elow=400 ehigh=7200 quad1=1 quad2=1 quad3=1 quad4=1 >& ../logs/"$i"-pn_bkg.log"
    pn_back prefix=S005 caldb=/raid2/dxb/xmm/downloads/FWC/ESAS/  diag=0 elow=400 ehigh=7200 quad1=1 quad2=1 quad3=1 quad4=1 >& ../logs/$i-pn_bkg.log
    echo "end part.backgnd.." $i
#
# Rotate maps
#
    echo 'rotate'
    rot-im-det-sky prefix=1S003 mask=0 elow=400 ehigh=7200 mode=1 >& ../logs/$i-mos1_rot.log
    rot-im-det-sky prefix=2S004 mask=0 elow=400 ehigh=7200 mode=1 >& ../logs/$i-mos2_rot.log
    rot-im-det-sky prefix=S005 mask=0 elow=400 ehigh=7200 mode=1 >& ../logs/$i-pn_rot.log
    echo "end.rotation.."
#
else
    echo "no particle background requested"
fi
#
#echo 'making cheese mask for Chandra sources mask_allsrc_04_06.fits'
#/usr/local/bin/python mask_fov_xmm_finoguenov.py
#/usr/local/bin/python mask_fov_xmm_finoguenov_chandra.py
#mv mask_allsrc_04_06.fits pnS005-cheese.fits
#
# File renaming
#
#fl_rename="0"
fl_rename="1"
if [ "$fl_rename" == 1 ];then
    echo "Renaming"
    mv mos1S003-obj.pi mos1S003-obj-full.pi
    mv mos1S003.rmf mos1S003-full.rmf
    mv mos1S003.arf mos1S003-full.arf
    mv mos1S003-back.pi mos1S003-back-full.pi
    
    mv mos1S003-back-im-sky-400-7200.fits mos1S003-back-im-sky-400-7200-full.fits
    mv mos1S003-bkgimage.fits mos1S003-bkgimage-full.fits 
    mv mos1S003-exp-im-400-7200.fits mos1S003-exp-im-400-7200-full.fits 
    mv mos1S003-mask-im-400-7200.fits mos1S003-mask-im-400-7200-full.fits 
    mv mos1S003-obj-im-400-7200.fits mos1S003-obj-im-400-7200-full.fits
       
    mv mos2S004-obj.pi mos2S004-obj-full.pi
    mv mos2S004.rmf mos2S004-full.rmf
    mv mos2S004.arf mos2S004-full.arf
    mv mos2S004-back.pi mos2S004-back-full.pi
    
    mv mos2S004-back-im-sky-400-7200.fits mos2S004-back-im-sky-400-7200-full.fits
    mv mos2S004-bkgimage.fits mos2S004-bkgimage-full.fits 
    mv mos2S004-exp-im-400-7200.fits mos2S004-exp-im-400-7200-full.fits 
    mv mos2S004-mask-im-400-7200.fits mos2S004-mask-im-400-7200-full.fits 
    mv mos2S004-obj-im-400-7200.fits mos2S004-obj-im-400-7200-full.fits
    
    mv pnS005-obj-os.pi pnS005-obj-os-full.pi
    mv pnS005-obj.pi pnS005-obj-full.pi
    mv pnS005-obj-oot.pi pnS005-obj-oot-full.fits
    mv pnS005.rmf pnS005-full.rmf
    mv pnS005.arf pnS005-full.arf
    mv pnS005-back.pi pnS005-back-full.pi
    
    mv pnS005-obj-im-sp-det.fits pnS005-obj-im-sp-full.fits
    mv pnS005-aug.qdp pnS005-aug-full.qdp
    
    mv pnS005-back-im-sky-400-7200.fits pnS005-back-im-sky-400-7200-full.fits
    mv pnS005-bkgimage.fits pnS005-bkgimage-full.fits 
    mv pnS005-exp-im-400-7200.fits pnS005-exp-im-400-7200-full.fits 
    mv pnS005-mask-im-400-7200.fits pnS005-mask-im-400-7200-full.fits 
    mv pnS005-obj-im-400-7200.fits pnS005-obj-im-400-7200-full.fits 
#
else
    echo "no renaming requested"
fi
#
# Atthkgen
#
#fl_att="0"
fl_att="1"
#
if [ "$fl_att" == "1" ];then
    echo "Atthkgen"
    echo "atthkgen  >& ../logs/"$i"-atthkgen.log"
    atthkgen  >& ../logs/$i-atthkgen.log						
#
else
    echo "no atthkgen requested"
fi
#
cp pnS005-obj-os-full.pi /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-pnS005-obj-os-full.pi
cp pnS005-back-full.pi /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-pnS005-back-full.pi
cp pnS005-full.rmf /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-pnS005-full.rmf
cp pnS005-full.arf /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-pnS005-full.arf
cp pnS005-cheese.fits /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-pnS005-cheese.fits

#cp mos1S003-obj-full.pi /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos1S003-obj-full.pi
#cp mos1S003-back-full.pi /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos1S003-back-full.pi
#cp mos1S003-full.rmf /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos1S003-full.rmf
#cp mos1S003-full.arf /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos1S003-full.arf
#cp mos1S003-cheese.fits /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos1S003-cheese.fits

#cp mos2S004-obj-full.pi /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos2S004-obj-full.pi
#cp mos2S004-back-full.pi /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos2S004-back-full.pi
#cp mos2S004-full.rmf /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos2S004-full.rmf
#cp mos2S004-full.arf /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos2S004-full.arf
#cp mos2S004-cheese.fits /raid2/dxb/xmm/analysis/COSMOS/sicong/xspec/$i-mos2S004-cheese.fits
#
echo "done" $i
done
#
echo "End part2"
