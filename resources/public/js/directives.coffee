



app.directive 'sparqlValue', ($rootScope) ->
  template: """
    <span ng-show="literal">{{v}}</span>
    <a href="#" ng-click="explore(v)" ng-hide="literal">{{prefixed}}</a>
    """
  link: (scope, element, attrs) -> 
    scope.$watch attrs.sparqlValue, (value) ->
      if value 
        if value.type is "uri" 
          scope.literal = false
          scope.v = value.value
          for prefix, uri of $rootScope.prefixes
            if value.value.indexOf(uri) is -1
              scope.prefixed = value.value
            else 
              return scope.prefixed = value.value.replace uri, prefix + ":" 
        else 
          scope.v = value.value
          scope.literal = true



app.directive 'prefixesArea', ($rootScope) ->
  template: """
    <div ng-repeat="(prefix, uri) in prefixes">test {}</div>
    """
  link: (scope, element, attrs) -> 
