#!/usr/bin/env bb

(require '[cheshire.core :as json]
         '[babashka.http-client :as http])

(def webhook-url (System/getenv "BOARD_GAME_NIGHT_WEBHOOK_URL"))
(def address (System/getenv "ADDRESS"))

(def at-seattle "<@&1265514409460240394>")

(def message (str "Hey " at-seattle " - board game night returns on Monday!

Come to **" address "** for game night on **Monday at 6pm**.

React with ✅ if you are coming!"))

(defn -main []
  (http/post webhook-url
             {:headers {"Content-Type" "application/json"}
              :body (json/encode {:content message})}))

(when (= *file* (System/getProperty "babashka.file"))
  (apply -main *command-line-args*))
