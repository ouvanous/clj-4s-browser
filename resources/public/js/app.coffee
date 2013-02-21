




# •••  APP                        •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
 
window.app = angular.module 'app', []



# •••  ROUTES                     •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


app.config [

  '$routeProvider',
  
  ($routeProvider) ->
    $routeProvider

      .when '/', 
        templateUrl: '/templates/index.html'
        controller: app.IndexCtrl

      .when '/port/:port', 
        templateUrl: '/templates/store.html'
        controller: app.StoreCtrl

      .otherwise
        redirectTo: '/'

]


