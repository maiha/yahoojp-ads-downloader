.rval.values
| select( . != null )
| .[]
| select(.operationSucceeded == true)
| .conversionTracker
| [leaf_paths as $path | {"key": [$path[] | tostring] | join("_"), "value": getpath($path)}] | from_entries
