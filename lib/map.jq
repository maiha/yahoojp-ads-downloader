def flatten_object:
  if type == "object" then
    .[] | flatten_object
  else
    .
  end
;

.rval.values
| select( . != null )
| .[]
| select(.operationSucceeded == true)
| .[$RECORD_KEY]
| [path(flatten_object) as $path |
  {
    "key": [$path[] | tostring] | join("_"),
    "value": getpath($path)
  }
  ] | from_entries
