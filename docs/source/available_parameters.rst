.. _parameters:

``parameters``
==============================

.. Samples the parameters for a graphical model with a given graph (specified in the ``data`` section).

``bin_bn``
--------------------


An object of this module defines a binary Bayesian network (where the nodes are binary variables) by sampling its conditional probability tables.
More specifically, the conditional probability tables for each variable :math:`Y_i` and parent configuration :math:`pa(Y_i)` are distributed as

.. math::

    P(Y_i=0 | pa(y_i) ) \sim \mathrm{Unif}([a, b]),

where  :math:`(a,b) \in [0,1]^2, a<b` and :math:`\mathrm{Unif}(c)` denotes the uniform distribution on the set :math:`c`.


.. Source: `resources/binarydatagen/generatebinaryBNf.r <https://github.com/felixleopoldo/benchpress/blob/master/resources/binarydatagen/generatebinaryBNf.r>`_

.. See `JSON schema <https://github.com/felixleopoldo/benchpress/blob/master/schema/docs/config-definitions-generatebinarybn.md>`_


.. rubric:: Example

.. code-block:: json

    {
        "id": "binbn",
        "min": 0.1,
        "max": 0.9
    }


``sem_params``
-------------------------------

An object of this module defines a Bayesian network by generating the weight matrix :math:`W` of a Gaussian linear structural equation model (SEM) of the form

.. math::

    Y_i=\sum_{j:Y_j\in pa(Y)} W_{ij}Y_j + Z_i,


where :math:`Z_i\sim \mathcal N(\mu, \sigma^2)` and elements of :math:`W` are distributed as
    
.. math::

    W_{ij} \sim 
    \begin{cases}
    \mathrm{Unif}([a, b])\mathrm{Unif}(\{-1,1\}) & \text{ if }(i, j) \in E\\
    0 & \text{ otherwise.}
    \end{cases}
    


.. See  `JSON schema <https://github.com/felixleopoldo/benchpress/blob/master/schema/docs/config-definitions-notears-parameter-sampling-for-gaissian-bayesian-networks.md>`_


.. rubric:: Example

.. code-block:: json

    {
        "id": "SEM",
        "min": 0.25,
        "max": 1
    }

``trilearn_hyper-dir``
-------------------------------

An object of the trilearn hyper-dir module defines a catagorical decomposable model by sampling the parameters from the hyper Dirichlet distribution [1]_, with specified equivalent sample size (``pseudo_obs``) and number of levels per variable (``n_levels``).


.. See  `JSON schema <https://github.com/felixleopoldo/benchpress/blob/master/schema/docs/config-definitions-notears-parameter-sampling-for-gaissian-bayesian-networks.md>`_


.. rubric:: Example

.. code-block:: json

    {
        "id": "disc-loglin",
        "n_levels": 2,
        "pseudo_obs": 1.0
    }


``trilearn_g_inv_wishart``
-------------------------------

An object of the trilearn hyper inv wishart module defines a zero-mean Gaussian decomposable model by sampling the covariance matrix from the *hyper inverse-Wishart* distribution [1]_ according to the procedure outlined by [2]_. 
The clique-wise scale matrices are fixed to the identity matrix and the degrees of freedom (``dof``) should be specified by the user.

.. See  `JSON schema <https://github.com/felixleopoldo/benchpress/blob/master/schema/docs/config-definitions-notears-parameter-sampling-for-gaissian-bayesian-networks.md>`_


.. rubric:: Example

.. code-block:: json

    {
        "id": "giw",
        "dof": 1
    }


``trilearn_intra-class``
-------------------------------

An object of the intraclass module defines a zero mean multivariate Gaussian distribution by its covariance matrix :math:`\Sigma` as 

.. math::
    
    \Sigma_{ij} = \begin{cases}
        \sigma^2, &\text{ if } i=j\\
        \rho\sigma^2, &\text{ if } (i,j) \in E \\
    \end{cases}



and :math:`\Sigma^{−1}_{ij} = 0 \text{ if } (i, j) \in  E \text{, where } \sigma^2 > 0  \text{ and } \rho \in [0, 1]` denote the variance and correlation coefficient, respectively.
Using an object id of this module in the ``parameters_id`` field of the ``data`` section requires that ``graph_id`` represents a decomposable graph.


.. See  `JSON schema <https://github.com/felixleopoldo/benchpress/blob/master/schema/docs/config-definitions-notears-parameter-sampling-for-gaissian-bayesian-networks.md>`_


.. rubric:: Example

.. code-block:: json
    
    {
        "id": "intra-class",
        "rho": 0.4,
        "sigma2": 1.0
    }

``bdgraph_rgwish``
------------------

Samples G-Wishart matrix given an undirected graph using the *rgwish* function from the R package  `BDgraph <https://cran.r-project.org/web/packages/BDgraph/index.html>`_.

Fixed parameters
-------------------------

* Bnlearn objects `bn.fit` objects should be stored in `RDS` format in the directory *resources/myparams/bn.fit_networks*.
* Weight matrices for SEM models should be stored in CSV format in *resources/myparams/sem_params*.


.. code-block:: json

    {
        "graph_id": "hepar2.csv",
        "parameters_id": "hepar2.rds",
        "data_id": "iid2000",
        "seed_range": [
            1,
            5
        ]
    }
    
.. rubric:: Example

Example standard networks mostly from the `bnlearn repository <https://www.bnlearn.com/bnrepository/>`_ are found `here <https://github.com/felixleopoldo/benchpress/tree/master/resources/parameters/myparams/bn.fit_networks>`_.


.. important::

    This must be combined with the correct graph of the network. For example, the network of ``asia.rds`` should be used with the graph ``asia.csv``, which happens the be corresponding adjacancy matrix.




.. [1] A. P. Dawid and S. L. Lauritzen. Hyper Markov laws in the statistical analysis of decomposable graphical models. The Annals of Statistics, 21(3):1272–1317, 1993.

.. [2] C. M. Carvalho, H. Massam, and M. West. Simulation of hyper-inverse Wishart distributions in graphical models. Biometrika, 94(3):647–659, 2007.