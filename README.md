# 		Mongodb version check Resource

A specific [Concourse](http://concourse.ci) resource that get the last mongodb sources where the rocksdb and mongotools have been provided too. It fetches the sources for compilation purpose

## Getting started
Add the following [Resource Type](http://concourse.ci/configuring-resource-types.html) to your Concourse pipeline
```yaml
resource_types:
  - name: mongodb-version
    type: docker-image
    source:
      repository: jraverdyorange/concourse-mongo-check-resource
```

## Source Configuration

### `source`:

#### Parameters

* `branch`: *Optional.* The main branch to check (ex "3.4").
* `version`: *Optional.* full version to fetch (ex: "3.4.7") 

An example source configuration is below.
```yaml
resources:
- name: get-last
  type: mongodb-version
  source:
    branch: "3.4"
```

