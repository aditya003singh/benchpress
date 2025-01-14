# This file reads a graph trajectory and returns an estimate such as the MAP graph,
# the mean graph, or the thresholded mean graph.

import sys
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import networkx as nx
import numpy as np
import matplotlib
import os
matplotlib.use('Agg')
sns.set_style("whitegrid")


def estimate_heatmap(df):
    heatmap = None
    for index, row in df.iterrows():
        if row["index"] == 0:
            heatmap = nx.to_numpy_array(g)

        if row["index"] > int(snakemake.params["burnin"]):
            cur_index = df["index"].iloc[index]
            prev_index = df["index"].iloc[index-1]
            reps = cur_index - prev_index
            heatmap += nx.to_numpy_matrix(g) * reps

        added = edges_str_to_list(row["added"], edgesymb)
        removed = edges_str_to_list(row["removed"], edgesymb)
        g.add_edges_from(added)
        g.remove_edges_from(removed)

    heatmap = heatmap / df["index"].iloc[-1]  # almost right
    return heatmap


def edges_str_to_list(str, edgesymb="-"):
    edges_str = str[1:-1].split(";")
    edges = [(edge.split(edgesymb)[0], edge.split(edgesymb)[1])
             for edge in edges_str if len(edge.split(edgesymb)) == 2]
    return edges

# Treating the case when empty files are created. Such files
# are created if the algorithm was timed out.
if os.stat(snakemake.input["traj"]).st_size > 0:
    df = pd.read_csv(snakemake.input["traj"], sep=",")

    if snakemake.params["graph_type"] == "dag":
        g = nx.DiGraph()
        edgesymb = "->"
    else:
        edgesymb = "-"
        g = nx.Graph()

    if snakemake.params["estimator"] == "map":
        maxscore = df[3:]["score"].max()
        for index, row in df.iterrows():
            added = edges_str_to_list(row["added"], edgesymb=edgesymb)
            removed = edges_str_to_list(row["removed"], edgesymb=edgesymb)
            g.add_edges_from(added)
            g.remove_edges_from(removed)
            if row["score"] == maxscore:
                break

        df_adjmat = pd.DataFrame(nx.to_numpy_array(g), dtype=int)
        df_adjmat.columns = g.nodes()
        df_adjmat.to_csv(snakemake.output["adjmat"], index=False)

    if snakemake.params["estimator"] == "heatmap":

        heatmap = estimate_heatmap(df)
        df_heatmap = pd.DataFrame(heatmap)
        df_heatmap.columns = g.nodes()
        df_heatmap.to_csv(snakemake.output["heatmap"], index=False)

    if snakemake.params["estimator"] == "threshold":
        heatmap = estimate_heatmap(df)
        adjmat = (heatmap > float(snakemake.params["threshold"])) * 1
        df_adjmat = pd.DataFrame(adjmat)
        df_adjmat.columns = g.nodes()
        df_adjmat.to_csv(snakemake.output["adjmat"], index=False)
else:
    if snakemake.params["estimator"] == "map" or snakemake.params["estimator"] == "threshold":
        open(snakemake.output["adjmat"],'a').close()
    if snakemake.params["estimator"] == "heatmap":
        open(snakemake.output["heatmap"],'a').close()