(ns clj-4s-browser.handler
  (:use compojure.core
        ring.middleware.json
        ring.util.response)
  (:require [compojure.handler :as handler]
            [compojure.route :as route]
            [clj-4s-browser.views :as views]
            [clj-4s-browser.api :as api]))






(defroutes api-routes
  (GET "/" [] api/index)
  (GET "/get" [] api/get)
  (POST "/post" [] api/post))




(defroutes app-routes
  (GET "/" [] views/index)
  (context "/api" [] api-routes)
  (route/resources "/")
  (route/not-found "Not Found"))



(def app
  (-> (handler/site app-routes)
      (wrap-json-body)
      (wrap-json-response)))
