









# -----------------------------------------------------------------------------
# 

app.IndexCtrl = ($scope, FourstoreService, $location) ->

  $scope.port = 8010
  $scope.open4store = (port) ->
    $location.path "/port/#{port}"











# -----------------------------------------------------------------------------
# 

app.StoreCtrl = ($scope, $routeParams, $rootScope, $timeout, FourstoreService) ->

  sparqlEditor = null
  $scope.port = $routeParams.port

  $scope.defaultQuery = """
  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  PREFIX ex: <http://example.com/>

  SELECT *
  WHERE {
    ?s ?p ?o
  }
  LIMIT 10
  """  
  $timeout () =>
    sparqlEditor  = CodeMirror.fromTextArea angular.element('textarea')[0]
  , 0

  $scope.get = () ->
    query = sparqlEditor.getValue()
    FourstoreService.get $scope.port, query, (response) ->
      $rootScope.prefixes = parsePrefixes query
      console.log $rootScope.prefixes
      if response.status is 200
        $scope.results = JSON.parse response.body
        Alertify.log.success "yes"
      else 
        Alertify.log.error 'no success'

  $scope.explore = (v) ->
    event.preventDefault()
    angular.element("#tabs-results li:eq(1) a").tab('show')
    FourstoreService.get $scope.port, """
      SELECT ?predicate ?object ?graph
      WHERE {
        GRAPH ?graph {
          <#{v}> ?predicate ?object .
        }
      }
    """, (res) ->
      if res.status is 200 
        $scope.po = JSON.parse res.body
    FourstoreService.get $scope.port, """
      SELECT ?subject ?object ?graph
      WHERE {
        GRAPH ?graph {
          ?subject <#{v}> ?object .
        }
      }
    """, (res) ->
      if res.status is 200 
        $scope.so = JSON.parse res.body
    FourstoreService.get $scope.port, """
      SELECT ?subject ?predicate ?graph
      WHERE {
        GRAPH ?graph {
          ?subject ?predicate <#{v}> .
        }
      }
    """, (res) ->
      if res.status is 200 
        $scope.sp = JSON.parse res.body




# -----------------------------------------------------------------------------
# 
parsePrefixes = (query) ->
  matches = query.match /PREFIX (.+): <(.+)>/g
  prefixes = {}
  matches.forEach (m) ->
    mm = m.match /(PREFIX (.+): <(.+)>)/
    prefixes[mm[2]] = mm[3] if mm[0]
  prefixes

