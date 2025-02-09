# This file contains rules for the different evaluation types.

rule compress:
    input:
        "{whatever}/adjvecs_tobecompressed.csv"
    output:
        "{whatever}/adjvecs.tar.gz"
    shell:
        "tar -cvzf {output} {input}"

rule extract:
    input:
        "{whatever}/adjvecs.tar.gz"
    output:
        temp("{whatever}/adjvecs.csv")
    shell:
        "tar -xvf {input} && mv {wildcards.whatever}/adjvecs_tobecompressed.csv {output}"


rule combine_benchmarks_data:
    input:
        "workflow/scripts/evaluation/combine_ROC_data.R",
        "workflow/scripts/evaluation/run_summarise.R",
        conf=configfilename,
        snake="workflow/Snakefile",
        algs=active_algorithm_files("benchmarks") # It should maybe be stated there which kind of benchmarks to be considered..
    output:
        csv="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] +"ROC_data.csv",
        joint="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] +"joint_benchmarks.csv"
    shell:        
        "Rscript workflow/scripts/evaluation/combine_ROC_data.R --joint_bench {output.joint} --filename {output.csv} --algorithms {input.algs} --config_filename {input.conf} "

rule benchmarks:
    input:
        "workflow/scripts/evaluation/plot_ROC.R",
        "workflow/scripts/evaluation/run_summarise.R",
        "workflow/Snakefile",
        config=configfilename,
        csv="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] +"ROC_data.csv",
        raw_bench="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] +"joint_benchmarks.csv"
    output: 
        temp(touch("results/output/benchmarks/benchmarks.done")),
        fpr_tpr_pattern="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "FPR_TPR_pattern.png",
        FPRp_FNR_skel="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "FPRp_FNR_skel.png",
        fnr_fprp_skel="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "FNR_FPR_skel.png",
        roc_FPRp_TPR_skel="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "FPR_TPR_skel.png",
        elapsed_time_joint="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "elapsed_time_joint.png",
        graph_type="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "graph_type.png",
        SHD_cpdag_joint="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "SHD_cpdag_joint.png",
        f1_skel_joint="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "f1_skel_joint.png",
        ntests_joint="results/output/benchmarks/"+config["benchmark_setup"]["evaluation"]["benchmarks"]["filename_prefix"] + "ntests_joint.png"

    script:
        "../scripts/evaluation/plot_ROC.R"

# Problem with seeds. The seed is includen in graph, bn and data, but not in algorithm.
# When the order of the data, parameters and data is changed, the seed is lost.
# It use to be matched out from data.

def traj_plots():
    ret = [[[[expand("{output_dir}/" \
            "evaluation=/{evaluation_string}/"\
            "adjmat=/{adjmat_string}/"\
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\
            "algorithm=/{alg_string}/" \
            "seed={seed}/"
            "traj_plot.eps",
            output_dir="results",
            alg_string=json_string_mcmc_noest[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            evaluation_string=gen_evaluation_string_from_conf("mcmc_traj_plots", alg_conf["id"]),
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in [mcmc_traj_conf["id"] for mcmc_traj_conf in config["benchmark_setup"]["evaluation"]["mcmc_traj_plots"] 
                                                            if ("active" not in mcmc_traj_conf) or (mcmc_traj_conf["active"] == True)] ]
            for alg in active_algorithms("mcmc_traj_plots")]
    return ret

def processed_trajs(mcmc_module):
    ret = [[[[expand("{output_dir}/" \
            "evaluation=/{evaluation_string}/"\
            "adjmat=/{adjmat_string}/"\
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\
            "algorithm=/{alg_string}/id={id}/"\
            "seed={seed}/"\
            "processed_graphtraj.csv",
            output_dir="results",
            alg_string=json_string_mcmc_noest[alg_conf["id"]],
            **alg_conf, # contains e.g. id
            seed=seed,
            evaluation_string=gen_evaluation_string_from_conf(mcmc_module, alg_conf["id"]),
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in [mcmc_traj_conf["id"] for mcmc_traj_conf in config["benchmark_setup"]["evaluation"][mcmc_module] 
                                                            if ("active" not in mcmc_traj_conf) or (mcmc_traj_conf["active"] == True)] ]
            for alg in active_algorithms(mcmc_module)]
    
    return ret


def bnlearn_graphvizcompare_plots(filename="graphvizcompare",ext="pdf"):
    ret = [[[[expand("{output_dir}/" \
            "evaluation=/{evaluation_string}/"\
            "adjmat=/{adjmat_string}/"\
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\
            "algorithm=/{alg_string}/" \
            "seed={seed}/" + \
            filename + "." + ext,
            output_dir="results",
            alg_string=json_string[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            evaluation_string="graphvizcompare/layout=True",
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"]) if sim_setup["graph_id"] != None]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                 if alg_conf["id"] in config["benchmark_setup"]["evaluation"]["graph_plots"]]
            for alg in active_algorithms("graph_plots")]
    return ret

def adjmat_diffplots(filename="adjmat_diffplot",ext="png"):
    ret = [[[[expand("{output_dir}/" \
            "evaluation=/{evaluation_string}/"\
            "adjmat=/{adjmat_string}/"\
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\
            "algorithm=/{alg_string}/" \
            "seed={seed}/" + \
            filename + "." + ext,
            output_dir="results",
            alg_string=json_string[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            evaluation_string="adjmat_diffplot",
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"]) if sim_setup["graph_id"] != None]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in config["benchmark_setup"]["evaluation"]["graph_plots"]]
            for alg in active_algorithms("graph_plots")]
    return ret

def adjmat_true_plots():
    return [[expand("{output_dir}/adjmat/{adjmat_string}.png",
            output_dir="results",
            seed=seed,
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed))
            for seed in get_seed_range(sim_setup["seed_range"]) ]
            for sim_setup in config["benchmark_setup"]["data"] ]

def adjmat_true_stats():
    return [[expand("{output_dir}/adjmatstats/{adjmat_string}/stats.csv",
            output_dir="results",
            seed=seed,
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed))
            for seed in get_seed_range(sim_setup["seed_range"]) ]
            for sim_setup in config["benchmark_setup"]["data"] ]

def adjmat_plots():
    ret = [[[[expand("{output_dir}/adjmat_estimate/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}/"
            "adjmat.eps",
            output_dir="results",
            alg_string=json_string[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in config["benchmark_setup"]["evaluation"]["graph_plots"]]
            for alg in active_algorithms("graph_plots")]
    return ret

def adjmats():
    ret = [[[[expand("{output_dir}/adjmat_estimate/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}/"
            "adjmat.csv",
            output_dir="results",
            alg_string=json_string[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in config["benchmark_setup"]["evaluation"]["graph_plots"]]
            for alg in active_algorithms("graph_plots")]
    return ret

def pairs():
    ret = [[expand("{output_dir}/pairs/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\                        
            "seed={seed}"
            ".png",
            output_dir="results",            
            
            seed=seed,          
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
    return ret

def graph_true_plots():
    return [[expand("{output_dir}/graph_plot/{adjmat_string}.png",
            output_dir="results",
            seed=seed,
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed))
            for seed in get_seed_range(sim_setup["seed_range"]) ]
            for sim_setup in config["benchmark_setup"]["data"] ]

def graph_plots():
    ret = [[[[expand("{output_dir}/graph_plot/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}.png",
            output_dir="results",
            alg_string=json_string[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in config["benchmark_setup"]["evaluation"]["graph_plots"]]
            for alg in active_algorithms("graph_plots")]
    return ret

def autocorr_plots():
    ret = [[[[expand("{output_dir}/" \
            "evaluation=/{evaluation_string}/"\
            "adjmat=/{adjmat_string}/"\
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\
            "algorithm=/{alg_string}/" \
            "seed={seed}/"
            "autocorr_plot.png",
            output_dir="results",
            alg_string=json_string_mcmc_noest[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            evaluation_string=gen_evaluation_string_from_conf("mcmc_autocorr_plots", alg_conf["id"]),
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in [conf["id"] for conf in config["benchmark_setup"]["evaluation"]["mcmc_autocorr_plots"] 
                                                    if ("active" not in conf) or (conf["active"] == True)] ]
            for alg in active_algorithms("mcmc_autocorr_plots")]
    return ret

def heatmap_plots():
    ret = [[[[expand("{output_dir}/" \
            "evaluation=/{evaluation_string}/"\
            "adjmat=/{adjmat_string}/"\
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\
            "algorithm=/{alg_string}/" \
            "seed={seed}/"
            "heatmap_plot.png",
            output_dir="results",
            alg_string=json_string_mcmc_noest[alg_conf["id"]],
            **alg_conf,
            seed=seed,
            evaluation_string=gen_evaluation_string_from_conf("mcmc_heatmaps", alg_conf["id"]),
            adjmat_string=gen_adjmat_string_from_conf(sim_setup["graph_id"], seed), 
            param_string=gen_parameter_string_from_conf(sim_setup["parameters_id"], seed),
            data_string=gen_data_string_from_conf(sim_setup["data_id"], seed, seed_in_path=False))
            for seed in get_seed_range(sim_setup["seed_range"])]
            for sim_setup in config["benchmark_setup"]["data"]]
            for alg_conf in config["resources"]["structure_learning_algorithms"][alg] 
                if alg_conf["id"] in [conf["id"] for conf in config["benchmark_setup"]["evaluation"]["mcmc_heatmaps"] 
                                                    if ("active" not in conf) or (conf["active"] == True)] ]
            for alg in active_algorithms("mcmc_heatmaps")]
    return ret


# From the alg id we could easily determine the varying paramter by checking which key has
# a list instead of a single value. But we need to match the id and we need to match the 
# parameters so that we can get the varying parameter value.


# Only get the pattern strings for the actual mcmc algorithms
mcmc_alg_ids = set()

for mcmc_dict in config["benchmark_setup"]["evaluation"]["mcmc_traj_plots"]:
    # get the actual conf
    
    alg_conf = None
    curalg = None
    for alg, algconfs in config["resources"]["structure_learning_algorithms"].items():  
        mcmc_alg_ids.add(alg)
# Create adapted anonymous MCMC rules where the algorithm parameters are matched.
for algid in mcmc_alg_ids:
    if algid in ["bidag_order_mcmc", "parallelDG", "trilearn_pgibbs", "gg99_singlepair", "gt13_multipair"]:
        # Processed graph trajectory
        rule:
            input:                 
                configfilename, # the variyng param might change
                "workflow/scripts/evaluation/write_graph_traj.py",                
                traj="{output_dir}/adjvecs/"\               
                    "adjmat=/{adjmat_string}/"\            
                    "parameters=/{param_string}/"\
                    "data=/{data_string}/"\
                    "algorithm=/"+pattern_strings[algid]+"/"\                            
                    "seed={seed}/"
                    "adjvecs.csv"        
            output:
                traj="{output_dir}/"\
                "evaluation=/" + pattern_strings["mcmc_traj_plots"] + "/"\ 
                "adjmat=/{adjmat_string}/"\            
                "parameters=/{param_string}/"\
                "data=/{data_string}/"\            
                "algorithm=/"+pattern_strings[algid]+"/id={id}/"\
                "seed={seed}/" \
                "processed_graphtraj.csv"
            params:
                alg=algid, # Maybe this should be matched in the pattern string instead
                data_string="{data_string}",
                adjmat_string="{adjmat_string}",
                param_string="{param_string}",
                alg_string=pattern_strings[algid],
                eval_string=pattern_strings["mcmc_traj_plots"],
                conf=configfilename
            container:
                docker_image("networkx")
            script:
                "../scripts/evaluation/write_graph_traj.py"

        # Auto correlations
        rule:
            input:                 
                "workflow/scripts/evaluation/write_graph_traj.py",                
                traj="{output_dir}/"\
                "evaluation=/" + pattern_strings["mcmc_traj_plots"] + "/"\ 
                "adjmat=/{adjmat_string}/"\            
                "parameters=/{param_string}/"\
                "data=/{data_string}/"\            
                "algorithm=/"+pattern_strings[algid]+"/id={id}/"\
                "seed={seed}/" \
                "processed_graphtraj.csv"    
            output:
                traj="{output_dir}/"\
                "evaluation=/" + pattern_strings["mcmc_autocorr_plots"] + "/"\ 
                "adjmat=/{adjmat_string}/"\            
                "parameters=/{param_string}/"\
                "data=/{data_string}/"\            
                "algorithm=/"+pattern_strings[algid]+"/id={id}/"\
                "seed={seed}/" \
                "processed_graphtraj.csv"
            params:
                alg=algid, # Maybe this should be matched in the pattern string instead
                data_string="{data_string}",
                adjmat_string="{adjmat_string}",
                param_string="{param_string}",
                alg_string=pattern_strings[algid],
                eval_string=pattern_strings["mcmc_autocorr_plots"]
            container:
                docker_image("networkx")
            script:
                "../scripts/evaluation/write_autocorr_traj.py"



rule mcmc_heatmap_plot:
    input: 
        "workflow/scripts/evaluation/plot_heatmap_from_graphtraj.py",
        traj="{output_dir}/adjvecs/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}/"\
            "adjvecs.csv"       
    output:
        filename="{output_dir}/"\
        "evaluation=/" + pattern_strings["mcmc_heatmaps"] + "/" \ 
        "adjmat=/{adjmat_string}/"\            
        "parameters=/{param_string}/"\
        "data=/{data_string}/"\            
        "algorithm=/{alg_string}/"\                            
        "seed={seed}/"
        "heatmap_plot.png"
    params:
        data_string="{data_string}",
        adjmat_string="{adjmat_string}",
        param_string="{param_string}",
        alg_string="{alg_string}"
    container:
        docker_image("networkx")
    script:
        "../scripts/evaluation/plot_heatmap_from_graphtraj.py"

rule adjmat_plot:
    input:
        "workflow/scripts/evaluation/plot_matrix_as_heatmap.py",
        matrix_filename="{output_dir}/adjmat_estimate/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}/"
            "adjmat.csv"
    output:
        plot_filename="{output_dir}/adjmat_estimate/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}/"
            "adjmat.eps"
    params:
        title="Graph: {adjmat_string}\nParameters: {param_string}\nData: {data_string}",
        adjmat_string="{adjmat_string}",
        param_string="{param_string}",
        data_string="{data_string}",
        alg_string="{alg_string}"
    container:
        docker_image("pydatascience")
    script:
        "../scripts/evaluation/plot_matrix_as_heatmap.py"

rule adjmat_true_plot:
    input:
        "workflow/scripts/evaluation/plot_matrix_as_heatmap.py",
        matrix_filename="{output_dir}/adjmat/{adjmat_string}.csv" 
    output:
        plot_filename = "{output_dir}/adjmat/{adjmat_string}.png"
    params:
        title="{adjmat_string}.csv",
        alg_string=""
    container:
        docker_image("pydatascience")
    script:
        "../scripts/evaluation/plot_matrix_as_heatmap.py"

rule adjmat_true_stats:
    input:
        "workflow/scripts/evaluation/graph_stats.R",
        matrix_filename="{output_dir}/adjmat/{adjmat_string}.csv" 
    output:
        stats_filename = "{output_dir}/adjmatstats/{adjmat_string}/stats.csv"
    params:
        title="{adjmat_string}.csv",
    script:
        "../scripts/evaluation/graph_stats.R"

# This rule is very generally specified and relies on that it is called in the right way.
# I.e with the path of an adjacency matrix.
rule adjmat_to_dot:
    input:
        "workflow/scripts/utils/adjmat_to_dot.py",
        filename="{output_dir}/adjmat_estimate/adjmat=/{something}/adjmat.csv" # true graph has adjmat in the path and estimated does not.
    output:
        filename = "{output_dir}/dotgraph/adjmat=/{something}.dot"
    container:
        docker_image("trilearn")
    shell:
        """
        if [ -s {input.filename} ]; then
            python workflow/scripts/utils/adjmat_to_dot.py {input.filename} {output.filename}
        else
            touch {output.filename}
        fi
        """

use rule adjmat_to_dot as true_adjmat_to_dot with:
    input:
        "workflow/scripts/utils/adjmat_to_dot.py",
        filename="{output_dir}/adjmat/{something}.csv" # true graph has /adjmat/ in the path and estimated does not.
    output:
        filename = "{output_dir}/dotgraph/{something}.dot"


rule plot_dot:
    input:
        filename="{output_dir}/dotgraph/{something}.dot" 
    output:
        filename="{output_dir}/graph_plot/{something}.png" 
    container:
        docker_image("trilearn")
    shell:
        """
        if [ -s {input.filename} ]; then
            dot -T png {input.filename} -o {output.filename}
        else
            touch {output.filename}
        fi
        """

rule mcmc_autocorr_plot:
    input: 
         "workflow/scripts/evaluation/plot_autocorr_from_traj.py",
         traj="{output_dir}/adjvecs/"\               
            "adjmat=/{adjmat_string}/"\            
            "parameters=/{param_string}/"\
            "data=/{data_string}/"\            
            "algorithm=/{alg_string}/"\                            
            "seed={seed}/"
            "adjvecs.csv"        
    output:
        plot="{output_dir}/"\
        "evaluation=/" + pattern_strings["mcmc_autocorr_plots"] + "/" \ 
        "adjmat=/{adjmat_string}/"\            
        "parameters=/{param_string}/"\
        "data=/{data_string}/"\            
        "algorithm=/{alg_string}/"\                            
        "seed={seed}/"
        "autocorr_plot.png"
    params:
        title="Graph: {adjmat_string}\nParameters: {param_string}\nData: {data_string}",
        adjmat_string="{adjmat_string}",
        param_string="{param_string}",
        data_string="{data_string}",
        alg_string="{alg_string}"
    container:
        docker_image("networkx")
    script:
        "../scripts/evaluation/plot_autocorr_from_traj.py"

rule mcmc_heatmaps:
    input:
        configfilename,
        plots=heatmap_plots()
    output:
        touch("results/output/mcmc_heatmaps/mcmc_heatmaps.done")
    run:
        for i,f in enumerate(input.plots):
            shell("cp "+f+" results/output/mcmc_heatmaps/heatmap_" +str(i+1) +".png")

# Joins processed trajs
rule mcmc_traj_plots_join_trajs:
    input:        
        trajs=processed_trajs("mcmc_traj_plots")
    output: 
        # having constant files makes triggering complicatad
        trajs="results/output/mcmc_traj_plots/mcmc_filled_trajs.csv" 
    script:
        "../scripts/evaluation/join_graph_trajs.py"

# This plots several trajectories in one figure
rule mcmc_traj_plots_plot_joined_trajs:
    input:
        configfilename,
        trajs=rules.mcmc_traj_plots_join_trajs.output.trajs
    output: 
        touch("results/output/mcmc_traj_plots/mcmc_traj_plots.done"),
        single=directory("results/output/mcmc_traj_plots/single_param_settings"),
        multi=directory("results/output/mcmc_traj_plots/multi_param_settings")
    params:
        xlab="Iteration"
    container:
        docker_image("pydatascience")
    script:
        "../scripts/evaluation/plot_multi_trajs.py"


# Joins processed trajs
rule mcmc_autocorr_plots_join_trajs:
    input:
        trajs=processed_trajs("mcmc_autocorr_plots") # should get lag trajs instead?
    output: 
        # separate based on the ids
        trajs="results/output/mcmc_autocorr_plots/joined_autocorr.csv" # Lag trajs
    script:
        # First compute the autocorrelation at each lag 
        "../scripts/evaluation/join_graph_trajs.py" 

# This plots several trajectories in one figure
rule mcmc_autocorr_plots_plot_joined_trajs:
    input:
        configfilename,
        trajs=rules.mcmc_autocorr_plots_join_trajs.output.trajs,
    output: 
        joined=touch("results/output/mcmc_autocorr_plots/mcmc_autocorr_plots_joined.done"),
        single=directory("results/output/mcmc_autocorr_plots/single_param_settings"),
        multi=directory("results/output/mcmc_autocorr_plots/multi_param_settings")
    params:
        xlab="Lag"
    container:
        docker_image("pydatascience")
    script:
        "../scripts/evaluation/plot_multi_trajs.py"

rule mcmc_autocorr_plots:
    input:
        configfilename,
        joined=rules.mcmc_autocorr_plots_plot_joined_trajs.output.joined,
        plots=autocorr_plots()
    output:
        touch("results/output/mcmc_autocorr_plots/mcmc_autocorr_plots.done"),
        dir=directory("results/output/mcmc_autocorr_plots/induvidual")
    run:
        for i,f in enumerate(input.plots):
            shell("mkdir -p {output.dir} && cp "+f+" {output.dir}/mcmc_autocorr_" +str(i+1) +".png")

rule join_adjmat_stats:
    input:
        conf=configfilename,
        res=adjmat_true_stats()
    output:
        "results/output/graph_true_stats/joint_stats.csv"
    script:
        "../scripts/evaluation/join_csv_files.R"

rule plot_adjmat_stats:
    input:    
        "workflow/scripts/evaluation/graph_stats_plot.R",
        conf=configfilename,
        joint_stats="results/output/graph_true_stats/joint_stats.csv"
    output:
        touch("results/output/graph_true_stats/graph_true_stats.done"),
        graph_density_plot="results/output/graph_true_stats/graph_density_plot.png"
    script:
        "../scripts/evaluation/graph_stats_plot.R"

rule plot_pairs:
    input:            
        "workflow/scripts/utils/pairs.R",        
        data=summarise_alg_input_data_path()        
    output:
        filename="{output_dir}/pairs/adjmat=/{adjmat}/parameters=/{bn}/data=/{data}/seed={replicate}.png",
    params:
        data="Graph:\n{adjmat}/parameters=/{bn}/data=/{data}/seed={replicate}"
    script:
        "../scripts/utils/pairs.R"

rule pairs:
    input:
        "workflow/scripts/utils/pairs.R",
        pairsplots=pairs() # This will not trigger the rule if these files have already been generated.
    output:
        temp(touch("results/output/ggally_ggpairs/ggally_ggpairs.done"))
    run:
        for i,f in enumerate(input.pairsplots):
            shell("cp "+f+" results/output/ggally_ggpairs/pairs_" +str(i+1) +".png")

# This is actually a quite general rule.
rule bnlearn_graphvizcompare:
    input:
        "workflow/scripts/evaluation/bnlearn_graphvizcompare.R",
        data = summarise_alg_input_data_path(),
        adjmat_true = summarise_alg_input_adjmat_true_path(),
        adjmat_est = "{output_dir}/adjmat_estimate/"\
                    "adjmat=/{adjmat}/"\
                    "parameters=/{bn}/"\
                    "data=/{data}/"\
                    "algorithm=/{alg_string}/"  \
                    "seed={replicate}/" \
                    "adjmat.csv"
    output:
        filename="{output_dir}/" \
        "evaluation=/graphvizcompare/layout={layout}/"\
        "adjmat=/{adjmat}/"\
        "parameters=/{bn}/"\
        "data=/{data}/"\
        "algorithm=/{alg_string}/" \
        "seed={replicate}/{filename}"
    script:
        "../scripts/evaluation/bnlearn_graphvizcompare.R"

# This is actually a quite general rule.
rule adjmat_diffplot:
    input:
        "workflow/scripts/evaluation/adjmat_diffplot.py",
        data = summarise_alg_input_data_path(),
        adjmat_true = summarise_alg_input_adjmat_true_path(),
        adjmat_est = "{output_dir}/adjmat_estimate/"\
                    "adjmat=/{adjmat}/"\
                    "parameters=/{bn}/"\
                    "data=/{data}/"\
                    "algorithm=/{alg_string}/"  \
                    "seed={replicate}/" \
                    "adjmat.csv"
    output:
        filename="{output_dir}/" \
        "evaluation=/adjmat_diffplot/"\
        "adjmat=/{adjmat}/"\
        "parameters=/{bn}/"\
        "data=/{data}/"\
        "algorithm=/{alg_string}/" \
        "seed={replicate}/{filename}"
    params:
        title="Graph: {adjmat}\nParameters: {bn}\nData: {data}",
        adjmat_string="{adjmat}",
        param_string="{bn}",
        data_string="{data}",
        alg_string="{alg_string}"
    container:
        docker_image("pydatascience")
    script:
        "../scripts/evaluation/adjmat_diffplot.py"

rule graph_plots:
    input:
        conf=configfilename,
        graphs=graph_plots(),
        adjmats=adjmat_plots(),
        adjmat_diffplots=adjmat_diffplots(),
        graphvizcompare=bnlearn_graphvizcompare_plots(),
        csv_adjmats=adjmats()
    output:
        directory("results/output/graph_plots/graphs"),
        directory("results/output/graph_plots/adjmats"),
        directory("results/output/graph_plots/adjmat_diffplots"),
        directory("results/output/graph_plots/csvs"),
        directory("results/output/graph_plots/graphvizcompare"),
        touch("results/output/graph_plots/graph_plots.done")
    run:
        for i,f in enumerate(input.graphs):
            shell("mkdir -p results/output/graph_plots/graphs && cp "+f+" results/output/graph_plots/graphs/graph_" +str(i+1) +".png")
        for i,f in enumerate(input.adjmats):
            shell("mkdir -p results/output/graph_plots/adjmats && cp "+f+" results/output/graph_plots/adjmats/adjmat_plot_" +str(i+1) +".eps")
        for i,f in enumerate(input.csv_adjmats):
            shell("mkdir -p results/output/graph_plots/csvs && cp "+f+" results/output/graph_plots/csvs/adjmat_" +str(i+1) +".csv")
        if True:
            shell("mkdir -p results/output/graph_plots/graphvizcompare")
            for i,f in enumerate(input.graphvizcompare):
                shell("cp "+f+" results/output/graph_plots/graphvizcompare/compare_" +str(i+1) +".pdf")

            shell("mkdir -p results/output/graph_plots/adjmat_diffplots")
            for i,f in enumerate(input.adjmat_diffplots):
                shell("cp "+f+" results/output/graph_plots/adjmat_diffplots/diffplot_" +str(i+1) +".png")

rule graph_true_plots:
    input:
        conf=configfilename,
        graphs=graph_true_plots(),
        adjmats=adjmat_true_plots()
    output:
        touch("results/output/graph_true_plots/graph_true_plots.done"),        
    run:
        for i,f in enumerate(input.graphs):
            shell("cp "+f+" results/output/graph_true_plots/graph_true_" +str(i+1) +".png")
        for i,f in enumerate(input.adjmats):
            shell("cp "+f+" results/output/graph_true_plots/adjmat_true_" +str(i+1) +".png")

