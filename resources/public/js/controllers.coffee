









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
  SELECT *
  WHERE {
    ?s ?p ?o
  }
  LIMIT 10
  """  


  $timeout () =>
    sparqlEditor  = CodeMirror.fromTextArea angular.element('.sparql-query')[0],
      theme: "elegant"
  , 0

  $scope.method = "get"

  $scope.changeQuery = (method) ->
    event.preventDefault()
    $scope.method = method
    $(event.target).tab('show')

  $scope.run = () ->
    query = $('.prefixes-area').text() + "\n" + sparqlEditor.getValue()
    if $scope.method is "get"
      get(query)
    else 
      post(query)

  get = (query) ->
    FourstoreService.get $scope.port, query, (response) ->
      if response.status is 200
        $scope.results = JSON.parse response.body
        Alertify.log.success "yes"
      else 
        Alertify.log.error 'no success'

  post = () ->
    query = sparqlEditor.getValue()
    FourstoreService.post $scope.port, query, (response) ->
      angular.element("#tabs-results li:eq(0) a").tab('show')
      $rootScope.prefixes = parsePrefixes query
      if response.status is 200
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

app.PrefixesCtrl = ($scope, $rootScope) ->
  $scope.tes = "eee"
  $rootScope.prefixes =   
    'rdf':          'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
    'rdfs':         'http://www.w3.org/2000/01/rdf-schema#'
    'dc11':           'http://purl.org/dc/elements/1.1/'
    'skos':         'http://www.w3.org/2004/02/skos/core#'
    'geonames':     'http://www.geonames.org/ontology#'
    'wgs84_pos':    'http://www.w3.org/2003/01/geo/wgs84_pos#'
    'dbpedia-owl':  'http://dbpedia.org/ontology/'
    'foaf':         'http://xmlns.com/foaf/0.1/'
    'owl':          'http://www.w3.org/2002/07/owl#'
    'schema':       'http://schema.org/'

  $rootScope.$watch "prefixes", (value) ->
    $scope.prefixesStr = sparqlPrefixes value

  $scope.addNewPrefix = (prefix, uri) ->
    if prefix and uri 
      $rootScope.prefixes[prefix] = uri
      $rootScope.$apply() unless $rootScope.$$phase


  sparqlPrefixes = (prefixes) ->
    _.map(prefixes, (prefix, uri) ->
      "PREFIX #{prefix}: <#{uri}> " 
    ).join("\n")