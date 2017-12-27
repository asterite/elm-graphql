module Github.Object.ExternalIdentityConnection exposing (..)

import Github.Object
import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


selection : (a -> constructor) -> SelectionSet (a -> constructor) Github.Object.ExternalIdentityConnection
selection constructor =
    Object.object constructor


edges : SelectionSet edges Github.Object.ExternalIdentityEdge -> FieldDecoder (List edges) Github.Object.ExternalIdentityConnection
edges object =
    Object.listOf "edges" [] object


nodes : SelectionSet nodes Github.Object.ExternalIdentity -> FieldDecoder (List nodes) Github.Object.ExternalIdentityConnection
nodes object =
    Object.listOf "nodes" [] object


pageInfo : SelectionSet pageInfo Github.Object.PageInfo -> FieldDecoder pageInfo Github.Object.ExternalIdentityConnection
pageInfo object =
    Object.single "pageInfo" [] object


totalCount : FieldDecoder Int Github.Object.ExternalIdentityConnection
totalCount =
    Object.fieldDecoder "totalCount" [] Decode.int
