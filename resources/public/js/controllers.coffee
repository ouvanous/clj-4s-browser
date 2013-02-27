









# -----------------------------------------------------------------------------
# 

app.IndexCtrl = ($scope, FourstoreService, $location) ->

  $scope.port = 8010
  $scope.open4store = (port) ->
    $location.path "/port/#{port}"


defaultQueries = 
  get: """
    SELECT *
    WHERE {
      ?s ?p ?o
    }
    LIMIT 10
    """  
  post: """ 
    INSERT {
      GRAPH <> {
        <> <> <> .
      }
    }
    """
  construct: """
    CONSTRUCT {
      ?s ?p ?o .
    }
    WHERE {
      ?s ?p ?o .
    }
    """

sessionQueries = _.clone defaultQueries





# -----------------------------------------------------------------------------
# 

app.StoreCtrl = ($scope, $routeParams, $rootScope, $timeout, FourstoreService) ->

  sparqlEditor = null
  turtleEditor = null
  $scope.port = $routeParams.port
  $scope.method = "get"

  $timeout () =>
    sparqlEditor  = CodeMirror.fromTextArea angular.element('.sparql-query')[0],
      theme: "elegant"
    turtleEditor  = CodeMirror.fromTextArea angular.element('#turtle-result')[0],
      theme: "elegant"
    sparqlEditor.setValue sessionQueries.get
  , 0




  $scope.changeQuery = (method) ->
    event.preventDefault()
    sessionQueries[$scope.method] = sparqlEditor.getValue()
    $scope.method = method
    sparqlEditor.setValue sessionQueries[method]
    $(event.target).tab('show')

  $scope.run = () ->
    sessionQueries[$scope.method] = sparqlEditor.getValue()
    $scope[$scope.method] $('.prefixes-area').text() + "\n" + sessionQueries[$scope.method]

  $scope.get = (query) ->
    FourstoreService.get $scope.port, query, (response) ->
      if response.status is 200
        $scope.results = JSON.parse response.body
        $scope.turtle = false
        angular.element("#tabs-results li:eq(0) a").tab('show')
        Alertify.log.success "showing results"
      else 
        Alertify.log.error 'unable to run this query'

  $scope.post = (query) ->
    FourstoreService.post $scope.port, query, (response) ->
      if response.status is 200
        $scope.changeQuery 'get'
        run()
        Alertify.log.success "update successed"
      else 
        Alertify.log.error 'unable to run this update query'

  $scope.construct = (query) ->
    FourstoreService.construct $scope.port, query, (response) ->
      console.log response
      $scope.turtle = response.body
      $scope.results = false
      turtleEditor.setValue response.body
      $timeout () ->
        turtleEditor.scrollTo 0, 0
      , 0
      if response.status is 200
        Alertify.log.success "construct successed"
      else 
        Alertify.log.error 'unable to run this query'

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
  
  unless localStorage.getItem "prefixes"
    localStorage.setItem "prefixes", JSON.stringify 
      'rdf':          'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
      'rdfs':         'http://www.w3.org/2000/01/rdf-schema#'
      'dc11':           'http://purl.org/dc/elements/1.1/'
      'skos':         'http://www.w3.org/2004/02/skos/core#'
      'foaf':         'http://xmlns.com/foaf/0.1/'
      'schema':       'http://schema.org/'

  prefixes = JSON.parse localStorage.getItem "prefixes"

  $rootScope.prefixes = prefixes


  $rootScope.$watch "prefixes", (value) ->
    $scope.prefixesStr = sparqlPrefixes value

  $scope.addPrefix = (prefix, uri) ->
    if prefix and uri 
      $rootScope.prefixes[prefix] = uri
      $rootScope.$apply() unless $rootScope.$$phase
      savePrefixes()

  $scope.modifyPrefix = (prefix, idx) ->
    $rootScope.prefixes[prefix] = $("#uri-"+idx).val()
    $rootScope.$apply() unless $rootScope.$$phase
    savePrefixes()

  $scope.deletePrefix = (prefix) ->
    delete $rootScope.prefixes[prefix]
    savePrefixes()

  sparqlPrefixes = (prefixes) ->
    _.map(prefixes, (prefix, uri) ->
      "PREFIX #{prefix}: <#{uri}> " 
    ).join("\n")

  savePrefixes = () ->
    localStorage.setItem "prefixes", JSON.stringify $rootScope.prefixes