(ns clj-4s-browser.api
  (:use compojure.core
        ring.util.response)
  (:require [clj4store.core :as c]
            [clojure.data.json :as json]))


; (def end-point (c/create-end-point "http://0.0.0.0:8020"))


(defn index 
  [req]
  "api docs")



(defn get
  [{{query :query end-point :endpoint} :params}]
  (let [res (c/get end-point query)]
    (locking System/out (println query))
    (response res)))



(defn post
  [{{query "query" end-point "endpoint"} :body}]
  (locking System/out (println query end-point))
  (let [res (c/post end-point query)]
    (response res)))

