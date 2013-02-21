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
    ; (locking System/out (println end-point))
    (response res)))

