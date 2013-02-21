
# ••• FourstoreService
# •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

app.factory 'FourstoreService', ($http) ->

  new class FourstoreService 
    
    get: (port, query, callback) ->
      $http
        method: "GET"
        url: "/api/get"
        params: 
          query: query
          endpoint: "http://localhost:" + port
      .success callback 

    
    post: (port, query, callback) ->
      $http
        method: "POST"
        url: "/api/post"
        data: 
          query: query
          endpoint: "http://localhost:" + port
      .success callback 

