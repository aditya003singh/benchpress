# This file pricudes a dict where the paths for all alforithms are generated based on the
# algorithm pattern strings and the values in the config file.
#
# MCMC methods are special since the the estimation parameters should not mix with the 
# parameters that define the run.
#
# Order MCMC is special in the sense that it can define a startspace by means 
# of the id of some algorithm. Thus the id has to be exptracted into a path string first.

def idtopath(mylist, json_string):
    if isinstance(mylist, list):
        return [json_string[startalg][0] for startalg in mylist]
    else:
        return json_string[str(mylist)]

json_string = {}

if "gt13_multipair" in pattern_strings:
    json_string = {val["id"]: expand(pattern_strings["gt13_multipair"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gt13_multipair"]}
if "gg99_singlepair" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gg99_singlepair"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gg99_singlepair"]})
if "bidag_itsearch" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["bidag_itsearch"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bidag_itsearch"]})
if "tetrad_fges" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_fges"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_fges"]})
if "notears" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["notears"], **val) 
                        for val in config["resources"]["structure_learning_algorithms"]["notears"]})
if "tetrad_fci" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_fci"], **val) 
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_fci"]})
if "tetrad_gfci" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_gfci"], **val) 
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_gfci"]})
if "tetrad_rfci" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_rfci"], **val) 
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_rfci"]})
if "tetrad_fofc" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_fofc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_fofc"]})
if "tetrad_ftfc" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_ftfc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_ftfc"]})
if "tetrad_fas" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_fas"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_fas"]})
if "tetrad_fask" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_fask"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_fask"]})
if "tetrad_pc-all" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_pc-all"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_pc-all"]})
if "tetrad_lingam" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_lingam"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_lingam"]})
if "tetrad_imgscont" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["tetrad_imgscont"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["tetrad_imgscont"]})
if "pcalg_pc" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["pcalg_pc"], **val)  
                        for val in config["resources"]["structure_learning_algorithms"]["pcalg_pc"]})
if "dualpc" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["dualpc"], **val)  
                        for val in config["resources"]["structure_learning_algorithms"]["dualpc"]})
if "bnlearn_mmhc" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["bnlearn_mmhc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_mmhc"]} )
if "bnlearn_interiamb" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["bnlearn_interiamb"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_interiamb"]} )
if "bnlearn_gs" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["bnlearn_gs"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_gs"]} )
if "bnlearn_tabu" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_tabu"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_tabu"]})
if "bnlearn_hc" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_hc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_hc"]})
if "bnlearn_pcstable" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_pcstable"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_pcstable"]})
if "bnlearn_iamb" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_iamb"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_iamb"]})
if "bnlearn_fastiamb" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_fastiamb"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_fastiamb"]})
if "bnlearn_iambfdr" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_iambfdr"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_iambfdr"]})
if "bnlearn_mmpc" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_mmpc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_mmpc"]})
if "bnlearn_sihitonpc" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_sihitonpc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_sihitonpc"]})
if "bnlearn_hpc" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_hpc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_hpc"]})
if "bnlearn_h2pc" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_h2pc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_h2pc"]})
if "bnlearn_rsmax2" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["bnlearn_rsmax2"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["bnlearn_rsmax2"]})
if "sklearn_glasso" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["sklearn_glasso"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["sklearn_glasso"]})
if "gobnilp" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gobnilp"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gobnilp"]})                      
if "trilearn_pgibbs" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["trilearn_pgibbs"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["trilearn_pgibbs"]})
if "parallelDG" in pattern_strings:
    json_string.update({val["id"]:  expand(pattern_strings["parallelDG"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["parallelDG"]})
if "rblip_asobs" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["rblip_asobs"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["rblip_asobs"]})
if "gcastle_notears" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_notears"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_notears"]})
if "gcastle_pc" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_pc"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_pc"]})
if "gcastle_anm" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_anm"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_anm"]})
if "gcastle_direct_lingam" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_direct_lingam"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_direct_lingam"]})
if "gcastle_ica_lingam" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_ica_lingam"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_ica_lingam"]})
if "gcastle_notears_nonlinear" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_notears_nonlinear"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_notears_nonlinear"]})
if "gcastle_notears_low_rank" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_notears_low_rank"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_notears_low_rank"]})
if "gcastle_golem" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_golem"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_golem"]})
if "gcastle_grandag" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_grandag"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_grandag"]})
if "gcastle_mcsl" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_mcsl"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_mcsl"]})
if "gcastle_gae" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_gae"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_gae"]})
if "gcastle_rl" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_rl"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_rl"]})
if "gcastle_corl" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["gcastle_corl"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gcastle_corl"]})
if "causaldag_gsp" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["causaldag_gsp"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["causaldag_gsp"]})
if "mylib_myalg" in pattern_strings:
    json_string.update({val["id"]: expand(pattern_strings["mylib_myalg"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["mylib_myalg"]})


# Order mcmc is special and has to be the last one since it takes input strings as start space.
# Also, the start space path has to be extracted first.
if "bidag_order_mcmc" in pattern_strings:
    order_mcmc_list = config["resources"]["structure_learning_algorithms"]["bidag_order_mcmc"]
    for items in order_mcmc_list:    
        items["startspace_algorithm"] = idtopath(items["startspace_algorithm"], json_string)

    json_string.update({val["id"]: expand(pattern_strings["bidag_order_mcmc"]+"/"+pattern_strings["mcmc_est"], **val,) 
                        for val in order_mcmc_list } )

if "bidag_partition_mcmc" in pattern_strings:
    bidag_partition_mcmc_list = config["resources"]["structure_learning_algorithms"]["bidag_partition_mcmc"]
    # The path to the startspace algorithm is extended here
    for items in bidag_partition_mcmc_list:    
        items["startspace_algorithm"] = idtopath(items["startspace_algorithm"], json_string)

    json_string.update({val["id"]: expand(pattern_strings["bidag_partition_mcmc"], **val,) 
                        for val in bidag_partition_mcmc_list } )

# Since we dont want the mcmc_est when we call the trajectory directly.
json_string_mcmc_noest = {}
if "bidag_order_mcmc" in pattern_strings:
    json_string_mcmc_noest.update({val["id"]: expand(pattern_strings["bidag_order_mcmc"], **val,) 
                        for val in order_mcmc_list } )
if "bidag_partition_mcmc" in pattern_strings:
    json_string_mcmc_noest.update({val["id"]: expand(pattern_strings["bidag_partition_mcmc"], **val,) 
                        for val in bidag_partition_mcmc_list } )
if "trilearn_pgibbs" in pattern_strings:
    json_string_mcmc_noest.update({val["id"]:  expand(pattern_strings["trilearn_pgibbs"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["trilearn_pgibbs"]})
if "parallelDG" in pattern_strings:
    json_string_mcmc_noest.update({val["id"]:  expand(pattern_strings["parallelDG"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["parallelDG"]})
if "gt13_multipair" in pattern_strings:
    json_string_mcmc_noest.update({val["id"]: expand(pattern_strings["gt13_multipair"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gt13_multipair"]})
if "gg99_singlepair" in pattern_strings:
    json_string_mcmc_noest.update({val["id"]: expand(pattern_strings["gg99_singlepair"], **val)
                        for val in config["resources"]["structure_learning_algorithms"]["gg99_singlepair"]})
