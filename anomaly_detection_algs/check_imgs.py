docker_imgs = ["adapad_novelty_svr", "adapad_phasespace_svm", "adapad_ensemble_gi", "adapad_grammarviz3", "adapad_hotsax", "adapad_ts_bitmap", "adapad_left_stampi", "adapad_numenta_htm", "adapad_subsequence_lof", "adapad_subsequence_if", "adapad_dwt_mlead", "adapad_fft", "adapad_sr", "adapad_s_h_esd", "adapad_dspot", "adapad_median_method", "adapad_sarima", "adapad_triple_es", "adapad_pci", "adapad_generic_rf", "adapad_generic_xgb", "adapad_tarzan", "adapad_health_esn", "adapad_ocean_wnn", "adapad_bagel", "adapad_donut", "adapad_img_embedding_cae", "adapad_sr_cnn", "adapad_subsequence_fast_mcd", "adapad_arima", "adapad_ssa", "adapad_norma", "adapad_sand", "adapad_series2graph"]

for img in docker_imgs:
    if img not in open("imgs_list.txt").read():
        print(img)