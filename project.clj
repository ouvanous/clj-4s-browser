(defproject clj-4s-browser "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [compojure "1.1.5"]
                 [clj4store "0.1.0"]
                 [hiccup "1.0.2"]
                 [ring/ring-json "0.1.2"]]
  :plugins [[lein-ring "0.8.2"]]
  :ring {:handler clj-4s-browser.handler/app}
  :profiles
  {:dev {:dependencies [[ring-mock "0.1.3"]]}})
