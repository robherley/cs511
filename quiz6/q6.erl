-module(q6).
-compile(export_all).

-type btree() :: {empty} | {node, number(), btree(), btree()}.

testTree() ->
    {node, 24, {node, 7, {node, 9, {empty}, {empty}}, {node, 12, {empty}, {empty}}},{node,8,{empty},{empty}}.