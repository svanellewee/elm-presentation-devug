module Main exposing (main)

import Html exposing (Html)
import Html exposing (text, div, ul, li)
import Json.Decode exposing (..)
import Json.Encode
import Json.Decode exposing (field, list)
import Json.Decode exposing (int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


{-

   https://medium.com/@eeue56/json-decoding-in-elm-is-still-difficult-cad2d1fb39ae
   https://thenewstack.io/taking-kubernetes-api-spin/

-}
{- Step 1 Do the upper level first..

   type alias PodList =
       { kind : String
       , apiVersion : String
       }


   podListDecoder : Decoder PodList
   podListDecoder =
       decode PodList
           |> required "kind" string
           |> required "apiVersion" string
-}
{- Step 2 Go into the struct and start expanding on the inner metadata code
   type alias PodListMetadata =
       { selfLink : String
       , resourceVersion : String
       }


   podListMetadataDecoder : Decoder PodListMetadata
   podListMetadataDecoder =
       decode PodListMetadata
           |> required "selfLink" string
           |> required "resourceVersion" string


   type alias PodList =
       { kind : String
       , apiVersion : String
       , metadata : PodListMetadata
       }


   podListDecoder : Decoder PodList
   podListDecoder =
       decode PodList
           |> required "kind" string
           |> required "apiVersion" string
           |> required "metadata" podListMetadataDecoder
-}


podListMetadataDecoder : Decoder PodListMetadata
podListMetadataDecoder =
    decode PodListMetadata
        |> required "selfLink" string
        |> required "resourceVersion" string


podListItemMetadataDecoder : Decoder PodListItemMetadata
podListItemMetadataDecoder =
    decode PodListItemMetadata
        |> required "name" string
        |> required "namespace" string
        |> required "selfLink" string
        |> required "creationTimestamp" string


podListItemDecoder : Decoder PodListItem
podListItemDecoder =
    decode PodListItem
        |> required "metadata" podListItemMetadataDecoder
        |> required "spec" podListItemSpecDecoder
        |> required "status" podListItemStatusDecoder


podListDecoder : Decoder PodList
podListDecoder =
    decode PodList
        |> required "kind" string
        |> required "apiVersion" string
        |> required "metadata" podListMetadataDecoder
        |> required "items" (list podListItemDecoder)


podListItemSpecContainerDecoder : Decoder PodListItemSpecContainer
podListItemSpecContainerDecoder =
    decode PodListItemSpecContainer
        |> required "name" string
        |> required "image" string


podListItemStatusDecoder : Decoder PodListItemStatus
podListItemStatusDecoder =
    decode PodListItemStatus
        |> required "phase" string


podListItemSpecDecoder : Decoder PodListItemSpec
podListItemSpecDecoder =
    decode PodListItemSpec
        |> required "containers" (list podListItemSpecContainerDecoder)


type alias PodListItemSpecContainer =
    { name : String
    , image : String
    }


type alias PodListItemStatus =
    { phase : String
    }


type alias PodListItemSpec =
    { containers : List PodListItemSpecContainer
    }


type alias PodListItemMetadata =
    { name : String
    , namespace : String
    , selfLink : String
    , creationTimeStamp : String
    }


type alias PodListItem =
    { metadata : PodListItemMetadata
    , spec : PodListItemSpec
    , status : PodListItemStatus
    }


type alias PodListMetadata =
    { selfLink : String
    , resourceVersion : String
    }


type alias PodList =
    { kind : String
    , apiVersion : String
    , metadata : PodListMetadata
    , items : List PodListItem
    }


exampleJson : String
exampleJson =
    """{
  "kind": "PodList",
  "apiVersion": "v1",
  "metadata": {
    "selfLink": "/api/v1/namespaces/default/pods",
    "resourceVersion": "4033"
  },
  "items": [
    {
      "metadata": {
        "name": "nginx",
        "namespace": "default",
        "selfLink": "/api/v1/namespaces/default/pods/nginx",
        "uid": "29c7d23c-6861-11e8-83a4-080027e07604",
        "resourceVersion": "1088",
        "creationTimestamp": "2018-06-05T01:38:35Z",
        "labels": {
          "name": "nginx"
        }
      },
      "spec": {
        "volumes": [
          {
            "name": "default-token-6h5hz",
            "secret": {
              "secretName": "default-token-6h5hz",
              "defaultMode": 420
            }
          }
        ],
        "containers": [
          {
            "name": "nginx",
            "image": "nginx",
            "ports": [
              {
                "containerPort": 80,
                "protocol": "TCP"
              }
            ],
            "resources": {
              "limits": {
                "cpu": "500m",
                "memory": "128Mi"
              },
              "requests": {
                "cpu": "500m",
                "memory": "128Mi"
              }
            },
            "volumeMounts": [
              {
                "name": "default-token-6h5hz",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "Always"
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst",
        "serviceAccountName": "default",
        "serviceAccount": "default",
        "nodeName": "test",
        "securityContext": {},
        "schedulerName": "default-scheduler"
      },
      "status": {
        "phase": "Running",
        "conditions": [
          {
            "type": "Initialized",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2018-06-05T01:38:35Z"
          },
          {
            "type": "Ready",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2018-06-05T01:40:25Z"
          },
          {
            "type": "PodScheduled",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2018-06-05T01:38:35Z"
          }
        ],
        "hostIP": "192.168.99.100",
        "podIP": "172.17.0.3",
        "startTime": "2018-06-05T01:38:35Z",
        "containerStatuses": [
          {
            "name": "nginx",
            "state": {
              "running": {
                "startedAt": "2018-06-05T01:40:24Z"
              }
            },
            "lastState": {},
            "ready": true,
            "restartCount": 0,
            "image": "nginx:latest",
            "imageID": "docker-pullable://nginx@sha256:b1d09e9718890e6ebbbd2bc319ef1611559e30ce1b6f56b2e3b479d9da51dc35",
            "containerID": "docker://6b54bd488badb038ed020c05646e68787c0331a589a08670c8d7669bdffbd81f"
          }
        ],
        "qosClass": "Guaranteed"
      }
    }
  ]
}"""


main : Html msg
main =
    let
        _ =
            Debug.log "test" "again"

        _ =
            decodeString (field "kind" string) exampleJson

        resultTest =
            decodeString podListDecoder exampleJson

        _ =
            Debug.log "hi" resultTest

        someList =
            [ "thing", "other thing" ]
    in
        case resultTest of
            Ok results ->
                let
                    items =
                        results.items
                in
                    div []
                        [ div []
                            [ text "Pod Status Summary" ]
                        , div []
                            [ ul []
                                (List.map (\l -> li [] [ text ("Pod: " ++ l.metadata.name ++ " " ++ l.metadata.namespace) ]) items)
                            ]
                        ]

            Err _ ->
                text "Computer says noooo"
