module Graphqelm.Generator.TypeLockDefinitions exposing (generateInterfaces, generateObjects, generateUnions)

import Graphqelm.Parser.ClassCaseName as ClassCaseName exposing (ClassCaseName)
import Graphqelm.Parser.Type as Type exposing (TypeDefinition(TypeDefinition))
import Interpolate exposing (interpolate)


generateUnions : List String -> List TypeDefinition -> ( List String, String )
generateUnions =
    generateCommon "Union" unionName


generateObjects : List String -> List TypeDefinition -> ( List String, String )
generateObjects =
    generateCommon "Object" objectName


generateInterfaces : List String -> List TypeDefinition -> ( List String, String )
generateInterfaces =
    generateCommon "Interface" interfaceName


generateCommon : String -> (TypeDefinition -> Bool) -> List String -> List TypeDefinition -> ( List String, String )
generateCommon typeName includeName apiSubmodule typeDefinitions =
    (let
        typesToGenerate =
            typeDefinitions
                |> List.filter includeName
                |> List.map (\(TypeDefinition name definableType description) -> name)
     in
     if typesToGenerate == [] then
        interpolate
            """module {0} exposing (..)


placeholder : String
placeholder =
    ""
"""
            [ apiSubmodule ++ [ typeName ] |> String.join "." ]
     else
        interpolate
            """module {0} exposing (..)


{1}
"""
            [ apiSubmodule ++ [ typeName ] |> String.join "."
            , typesToGenerate
                |> List.map generateType
                |> String.join "\n\n\n"
            ]
    )
        |> (\fileContents -> ( apiSubmodule ++ [ typeName ], fileContents ))


generateType : ClassCaseName -> String
generateType name =
    interpolate
        """type {0}
    = {0}"""
        [ ClassCaseName.normalized name ]


objectName : TypeDefinition -> Bool
objectName (TypeDefinition name definableType description) =
    case definableType of
        Type.ObjectType _ ->
            True

        Type.InterfaceType _ _ ->
            False

        Type.ScalarType ->
            False

        Type.EnumType _ ->
            False

        Type.UnionType _ ->
            False


unionName : TypeDefinition -> Bool
unionName (TypeDefinition name definableType description) =
    case definableType of
        Type.ObjectType _ ->
            False

        Type.InterfaceType _ _ ->
            False

        Type.ScalarType ->
            False

        Type.EnumType _ ->
            False

        Type.UnionType _ ->
            True


interfaceName : TypeDefinition -> Bool
interfaceName (TypeDefinition name definableType description) =
    case definableType of
        Type.ObjectType _ ->
            False

        Type.InterfaceType _ _ ->
            True

        Type.ScalarType ->
            False

        Type.EnumType _ ->
            False

        Type.UnionType _ ->
            False