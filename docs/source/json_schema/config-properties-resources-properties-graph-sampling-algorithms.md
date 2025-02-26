# Graph sampling algorithms Schema

```txt
http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph
```

The available graph sampling algorithms.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [config.schema.json*](config.schema.json "open original schema") |

## graph Type

`object` ([Graph sampling algorithms](config-properties-resources-properties-graph-sampling-algorithms.md))

# graph Properties

| Property                              | Type    | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                               |
| :------------------------------------ | :------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [pcalg_randdag](#pcalg_randdag)       | `array` | Optional | cannot be null | [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-list-of-pcalg_randdag-objects.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/pcalg_randdag") |
| [notears](#notears)                   | `array` | Optional | cannot be null | [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-notears-dag-sampling-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/notears")            |
| [trilearn_cta](#trilearn_cta)         | `array` | Optional | cannot be null | [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-christmas-tree-algorithm-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/trilearn_cta")   |
| [bandmat](#bandmat)                   | `array` | Optional | cannot be null | [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-band-matrix-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/bandmat")                     |
| [rand_bandmat](#rand_bandmat)         | `array` | Optional | cannot be null | [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-random-sized-band-matrix-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/rand_bandmat")   |
| [bdgraph_graphsim](#bdgraph_graphsim) | `array` | Optional | cannot be null | [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-bdgraph-graphsim.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/bdgraph_graphsim")           |

## pcalg_randdag

List of pcalg_randdag objects

`pcalg_randdag`

*   is optional

*   Type: `object[]` ([pcalg randDAG](config-definitions-pcalg-randdag.md))

*   cannot be null

*   defined in: [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-list-of-pcalg_randdag-objects.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/pcalg_randdag")

### pcalg_randdag Type

`object[]` ([pcalg randDAG](config-definitions-pcalg-randdag.md))

### pcalg_randdag Constraints

**unique items**: all items in this array must be unique. Duplicates are not allowed.

## notears



`notears`

*   is optional

*   Type: unknown\[] ([Notears DAG sampling](config-definitions-notears-dag-sampling.md))

*   cannot be null

*   defined in: [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-notears-dag-sampling-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/notears")

### notears Type

unknown\[] ([Notears DAG sampling](config-definitions-notears-dag-sampling.md))

### notears Constraints

**unique items**: all items in this array must be unique. Duplicates are not allowed.

## trilearn_cta



`trilearn_cta`

*   is optional

*   Type: unknown\[] ([CTA decomposable graph sampling](config-definitions-cta-decomposable-graph-sampling.md))

*   cannot be null

*   defined in: [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-christmas-tree-algorithm-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/trilearn_cta")

### trilearn_cta Type

unknown\[] ([CTA decomposable graph sampling](config-definitions-cta-decomposable-graph-sampling.md))

### trilearn_cta Constraints

**unique items**: all items in this array must be unique. Duplicates are not allowed.

## bandmat



`bandmat`

*   is optional

*   Type: unknown\[] ([Band matrix](config-definitions-band-matrix.md))

*   cannot be null

*   defined in: [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-band-matrix-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/bandmat")

### bandmat Type

unknown\[] ([Band matrix](config-definitions-band-matrix.md))

### bandmat Constraints

**unique items**: all items in this array must be unique. Duplicates are not allowed.

## rand_bandmat



`rand_bandmat`

*   is optional

*   Type: unknown\[] ([Random band matrix](config-definitions-random-band-matrix.md))

*   cannot be null

*   defined in: [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-random-sized-band-matrix-ids.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/rand_bandmat")

### rand_bandmat Type

unknown\[] ([Random band matrix](config-definitions-random-band-matrix.md))

### rand_bandmat Constraints

**unique items**: all items in this array must be unique. Duplicates are not allowed.

## bdgraph_graphsim



`bdgraph_graphsim`

*   is optional

*   Type: unknown\[] ([Random undirected graph](config-definitions-random-undirected-graph.md))

*   cannot be null

*   defined in: [JSON schema for BenchPress config file.](config-properties-resources-properties-graph-sampling-algorithms-properties-bdgraph-graphsim.md "http://github.com/felixleopoldo/benchpress/workflow/schemas/config.schema.json#/properties/resources/properties/graph/properties/bdgraph_graphsim")

### bdgraph_graphsim Type

unknown\[] ([Random undirected graph](config-definitions-random-undirected-graph.md))

### bdgraph_graphsim Constraints

**unique items**: all items in this array must be unique. Duplicates are not allowed.
