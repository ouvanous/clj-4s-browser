(ns clj-4s-browser.views
  (:use hiccup.core)
  (:use hiccup.page))


(defn layout
  [& content]
  (html
    (doctype :html5)
    [:head 
      [:title "sam"]
      (include-css "/css/styles.css")
      (include-js "/js/libs.min.js" "/js/app.js")
      ]
    [:body  {"ng-app" "app"} content]))




(defn index 
  [req]
  (layout 
    [:div#wrap.container
      [:header 
        [:h1 "clj-4s-browser"]]
      [:div.ng-view  "loading...."]]))