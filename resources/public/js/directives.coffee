



app.directive 'sparqlValue', ($rootScope) ->
  template: """
    <span ng-show="literal">{{v}}</span>
    <a href="#" ng-click="explore(v)" ng-hide="literal" data-uri="{{v}}">{{prefixed}}</a>
    """
  link: (scope, element, attrs) -> 
    prefixes = $rootScope.prefixes
    scope.$watch attrs.sparqlValue, (value) ->
      if value 
        if value.type is "uri" 
          scope.literal = false
          for prefix, uri of prefixes
            if value.value.indexOf(uri) is 0 
              scope.prefixed = value.value.replace uri, prefix + ":" 
            scope.v = value.value
        else 
          scope.v = value.value
          scope.literal = true



