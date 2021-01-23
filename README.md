# Spetral-Analysis-for-COSMOS-field
This project generates and fits spectra from XMM observations of the COSMOS field to study the potential spatial variation of Emission Measure of Galactic Halo/ Circum-galactic medium.

See https://www.notion.so/COSMOS-PROJECT-REPORT-32ae90c1ffc44f1183ec8f7faea160fb for full reports

To generate spectra, see run_xmm_cosmos.sh

Phase 1 aims to generate, co-add spectra, and fit the composite spectrum in each box region (10 arcmin width).

Phase 2 aims to fit the individual spectra from different pointings in the same box region simultaneously, as a workaround to bugs produced in the process of combining spectra. This new fitting strategy allows me to manually inspect and remove bad pointings in each region and can significantly improve reduced chi square statistics.

Phase 3 aims to combine spectra from all pointings and fit with an additional Gaussian around 0.9 keV for potential Ne IX emission line.
