#!/bin/sh
#

# Run a several tasks for data reduction and analysis select and deselec (by commenting) the required tasks

. /usr/local/xmmsas_20160201_1833/setsas.sh 
echo $SAS_DIR
echo $SAS_PATH

# Loop on datasets
#

#

for i in 0203360101 0203360201 0203360301 0203360401 0203360501 0203360601 0203360701 0203360801 0203360901 0203361001 0203361101 0203361201 0203361301 0203361401 0203361501 0203361601 0203361701 0203361801 0203361901 0203362001 0203362101 0203362201 0203362301 0203362401 0203362501 0302350101 0302350201 0302350301 0302350401 0302350501 0302350601 0302350701 0302350801 0302350901 0302351001 0302351101 0302351201 0302351301 0302351401 0302351501 0302351601 0302351701 0302351801 0302351901 0302352001 0302352201 0302352301 0302352401 0302352501 0302353001 0302353101 0302353201 0302353301 0302353401 0501170101 0501170201
do

# Set ODF and CAL paths
#
SAS_ODF=/raid2/dxb/xmm/analysis/COSMOS/sicong/$i/ODF; export SAS_ODF
echo $SAS_ODF
#SAS_CCFPATH=/raid2/dxb/xmm/downloads/ccf; export SAS_CCFPATH
SAS_CCFPATH=/raid2/dxb/xmm/analysis/COSMOS/sicong/ccf; export SAS_CCFPATH
echo $SAS_CCFPATH
#

#
cd /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
SAS_CCF=/raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis/ccf.cif; export SAS_CCF
echo $SAS_CCF
echo "building CIF"
cifbuild withccfpath=no analysisdate=now category=XMMCCF calindexset=$SAS_CCF fullpath=yes >& ../logs/cifbuid.log
echo $SAS_CCF

echo "build ODF summary file"
odfingest odfdir=$SAS_ODF outdir=$SAS_ODF >& ../logs/odfingest.log
#

echo "$i" > obs_id
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/XMM_fk5.reg  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/FinoguenovCluster_fk5.reg  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/Chandra_fk5.reg  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/CDFS4MS.fits  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/chandra_reg.py  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/poly_input.reg  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
cp /raid2/dxb/xmm/analysis/COSMOS/sicong/chandra/src/CLS.tsv  /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis/CLS_all.tsv

#cp /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/make_bkg_region_sky_cos.py  /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
#cp /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/make_bkg_region_withradec_cos.py /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/change_radius.py /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/COSMOS/sicong/scripts/append_bkg_region.py /raid2/dxb/xmm/analysis/COSMOS/sicong/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/mask_fov_xmm_finoguenov.py  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/mask_fov_xmm_finoguenov_chandra.py  /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis
#cp /raid2/dxb/xmm/analysis/CDFS/hsc/mapfiles/exposure_all_04_06_threshold.fits /raid2/dxb/xmm/analysis/CDFS/hsc/ellipse/$i/analysis

#chmod +x make_bkg_region_sky_el.py
#chmod +x make_bkg_region_withradec_el.py
#chmod +x change_radius.py
#chmod +x append_bkg_region.py
#chmod +x chandra_reg.py
#chmod +x mask_fov_xmm_finoguenov.py
#chmod +x mask_fov_xmm_finoguenov_chandra.py
#

echo "working on" $i
#done
# Clean and filter procedure (required only once to prepare clean datasets)
# It will close with some renaming of useful files and removal of unused files
#
#fl_clean="0"
fl_clean="1"
#
if [ "$fl_clean" == 1 ]; then
    echo "start epchain"
    echo "epchain withoutoftime=true verbosity=1 >& ../logs/"$i"-epchain_oot.log"
#    epchain withoutoftime=true verbosity=1 >& ../logs/$i-epchain_oot.log
    epchain withoutoftime=true >& ../logs/$i-epchain_oot.log
    echo "epchain verbosity=1 >& ../logs/"$i"-epchain.log"
    epchain >& ../logs/$i-epchain.log
    echo "emchain verbosity=1 >& ../logs/"$i"-emchain.log"
    emchain >& ../logs/$i-emchain.log 
    echo "Start filtering"
    echo "mos-filter >& ../logs/"$i"-mos-filter.log"
    mos-filter >& ../logs/$i-mos-filter.log
    echo "pn-filter >& ../logs/"$i"-pn-filter.log"
    pn-filter >& ../logs/$i-pn-filter.log
    echo "end filtering.."
#rename some useful files (the filtering is supposed to do that, but it does not)
    echo "Renaming"
#
#    rm mos1U002*
 #   rm mos2U002* 
#
#    if [ "$i" == 0555780801 ]; then
#	rm mos1U002*
#	rm mos2U002* 
 #   fi

#    if [ "$i" == 0555782301 ]; then
#	rm mos1U002*
#	rm mos2U002* 
 #   fi
#
    rename mos1U002 mos1S001 mos1U002*  # for unscheduled observations
    rename mos1S007 mos1S001 mos1S007* 
    rename mos2S008 mos2S002 mos2S008*  # for unscheduled observations
    rename mos2U002 mos2S002 mos2U002*
    rename pnU002 pnS003 pnU002*  # for unscheduled observations
    rename pnU003 pnS003 pnU003*
    rename pnS009 pnS003 pnS009*
    
    mv mos1S001-clean.fits mos1S003-clean.fits
    mv mos1S001-gti.fits mos1S003-gti.fits
    mv mos1S001-gti.txt mos1S003-gti.txt 
    mv mos1S001-hist.qdp mos1S003-hist.qdp 
    mv mos1S001-ratec.fits mos1S003-ratec.fits 
    mv mos1S001-rate.fits mos1S003-rate.fits 
    mv mos1S001-corn.fits mos1S003-corn.fits
    mv mos1S001-corn-image.fits mos1S003-corn-image.fits
    mv mos1S001-obj-image-det.fits mos1S003-obj-image-det.fits
    mv mos1S001-obj-image-det-soft.fits mos1S003-obj-image-det-soft.fits
    mv mos1S001-obj-image-det-unfilt.fits mos1S003-obj-image-det-unfilt.fits
    mv mos1S001-obj-image-sky.fits mos1S003-obj-image-sky.fits
    mv mos1S001-ori.fits mos1S003-ori.fits

    mv mos2S002-clean.fits mos2S004-clean.fits
    mv mos2S002-gti.fits mos2S004-gti.fits
    mv mos2S002-gti.txt mos2S004-gti.txt 
    mv mos2S002-hist.qdp mos2S004-hist.qdp 
    mv mos2S002-ratec.fits mos2S004-ratec.fits 
    mv mos2S002-rate.fits mos2S004-rate.fits 
    mv mos2S002-corn.fits mos2S004-corn.fits
    mv mos2S002-corn-image.fits mos2S004-corn-image.fits
    mv mos2S002-obj-image-det.fits mos2S004-obj-image-det.fits
    mv mos2S002-obj-image-det-soft.fits mos2S004-obj-image-det-soft.fits
    mv mos2S002-obj-image-det-unfilt.fits mos2S004-obj-image-det-unfilt.fits
    mv mos2S002-obj-image-sky.fits mos2S004-obj-image-sky.fits
    mv mos2S002-ori.fits mos2S004-ori.fits

    mv pnS003-clean.fits pnS005-clean.fits 
    mv pnS003-clean-oot.fits pnS005-clean-oot.fits 
    mv pnS003-gti.fits pnS005-gti.fits 
    mv pnS003-gti-oot.fits pnS005-gti-oot.fits 
    mv pnS003-gti-oot.txt pnS005-gti-oot.txt 
    mv pnS003-gti.txt pnS005-gti.txt 
    mv pnS003-hist-oot.qdp pnS005-hist-oot.qdp 
    mv pnS003-hist.qdp pnS005-hist.qdp 
    mv pnS003-ratec.fits pnS005-ratec.fits 
    mv pnS003-ratec-oot.fits pnS005-ratec-oot.fits 
    mv pnS003-rate.fits pnS005-rate.fits
    mv pnS003-rate-oot.fits pnS005-rate-oot.fits 
    mv pnS003-obj-image-det.fits pnS005-obj-image-det.fits
    mv pnS003-obj-image-det-oot.fits pnS005-obj-image-det-oot.fits
    mv pnS003-obj-image-det-unfilt.fits pnS005-obj-image-det-unfilt-oot.fits
    mv pnS003-obj-image-det-unfilt-oot.fits pnS005-obj-image-det-unfilt-oot.fits
    mv pnS003-obj-image-sky.fits pnS005-obj-image-sky.fits
    mv pnS003-obj-image-sky-oot.fits pnS005-obj-image-sky-oot.fits
    mv pnS003-oot.fits pnS005-oot.fits
    mv pnS003-ori.fits pnS005-ori.fits
    echo "end renaming"
#    
# Remove unused files
    rm -f *.FIT
#
else
    echo "no epchain requested"
fi
#
# Remove cheese maps, choose if you want to use single or multiple bands
#
#fl_cheese="0"
fl_cheese="1"
if [ "$fl_cheese" == 1 ]; then
    echo "Start cheese"
    echo "cheese prefixm="1S003 2S004" prefixp=S005 scale=0.2 rate=0.1 dist=5.0 clobber=1 elow=400 ehigh=7200 >& ../logs/"$i"-cheese.log"
    cheese prefixm="1S003 2S004" prefixp=S005 scale=0.2 rate=0.1 dist=5.0 clobber=1 elow=400 ehigh=7200 >& ../logs/$i-cheese.log
    #cheese prefixp=S005 scale=0.2 rate=0.1 dist=5.0 clobber=1 elow=400 ehigh=600 >& ../logs/$i-cheese.log
    #cheese-bands prefixm="1S003 2S004" prefixp=S005 scale=0.2 ratet=0.1 rates=0.1 rateh=0.1 dist=5.0 clobber=1 elowlist="400 2000" ehighlist="1250 7200"  >& ../logs/$i-cheese.log
    #mv pnS005-cheese.fits pnS005-original-cheese.fits
    echo "end cheese .."
#
else
    echo "no cheese requested"
fi
#
#
echo "making pnS005-bkg_region-sky.fits & pnS005-bkg_region-det.fits"
mv pnS005-bkg_region-sky.fits pnS005-bkg_region-sky-original.fits
mv pnS005-bkg_region-det.fits pnS005-bkg_region-det-original.fits
#mv mos1S003-bkg_region-sky.fits mos1S003-bkg_region-sky-original.fits
#mv mos1S003-bkg_region-det.fits mos1S003-bkg_region-det-original.fits
#mv mos2S004-bkg_region-sky.fits mos2S004-bkg_region-sky-original.fits
#mv mos2S004-bkg_region-det.fits mos2S004-bkg_region-det-original.fits

#. /usr/local/xmmsas_20160201_1833/setsas.sh 
#SAS_ODF=/raid2/dxb/xmm/downloads/CDFS/$i/ODF/summary.sas;export SAS_ODF
#echo $SAS_ODF
#SAS_CCFPATH=/raid2/dxb/xmm/downloads/ccf; export SAS_CCFPATH
#SAS_CCFPATH=/raid2/dxb/xmm/analysis/hsc/ccf; export SAS_CCFPATH
#echo $SAS_CCFPATH
#SAS_CCF=/raid2/dxb/xmm/analysis/CDFS/hsc/$i/analysis/ccf.cif; export SAS_CCF
done

#
echo "End part1"
