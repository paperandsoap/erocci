%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2013, Jean Parpaillon
%%% @doc
%%%
%%% @end
%%% Created : 29 Aug 2013 by Jean Parpaillon <jean.parpaillon@free.fr>
-module(occi_entity).
-compile([{parse_transform, lager_transform}]).

-include("occi.hrl").

-export([save/1]).
-export([get_cid/1,
	 get_id/1,
	 set_attributes/2, 
	 set_attribute/3]).

%%%
%%% API
%%%
save(Entity) when is_record(Entity, occi_resource); 
		  is_record(Entity, occi_link) ->
    Cid = get_cid(Entity),
    Backend = occi_store:get_backend(Cid),
    occi_backend:save(Backend, Entity).

get_cid(Entity) when is_record(Entity, occi_resource); 
		    is_record(Entity, occi_link) ->
    element(3, Entity).

get_id(Entity) when is_record(Entity, occi_resource); 
		    is_record(Entity, occi_link) ->
    element(2, Entity).

set_attributes(Specs, Values) ->
    {Attrs, Errors, Specs2} = set_attributes2(Specs, Values),
    % TODO: check spec coherence
    % If attribute is immutable, it can not be set by user ?
    % Do not check it, so...
    Specs3 = dict:filter(fun(_K, {P, _Cb}) ->
			       not lists:member(immutable, P)
		       end, Specs2),
    % Check remaining attributes are not required
    Errors2 = dict:fold(fun(K, {P, _Cb}, Acc) ->
				case lists:member(required, P) of
				    true -> [{einval, K}|Acc];
				    false -> Acc
				end
			end, Errors, Specs3),
    {Attrs, Errors2}.

set_attribute(K, {P, {M, F, Args}}, Obj) ->
    case lists:member(immutable, P) of
	true ->
	    {error, {einval, K}};
	false ->
	    Ret = case Args of
		      [] -> M:F(Obj);
		      L -> M:F(Obj, L)
		  end,
	    case Ret of
		{ok, Val} ->
		    {ok, K, Val};
		error ->
		    {error, {einval, K}}
	    end
    end.

%%%
%%% Private
%%%
set_attributes2(Specs, Values) ->
    lists:foldl(fun({K, V}, {AccAttrs, AccErrors, AccSpecs}) ->
			case set_attribute(K, dict:fetch(K, AccSpecs), V) of
			    {ok, K, V} ->
				{[{K, V}|AccAttrs], AccErrors, dict:erase(K, AccSpecs)};
			    {error, Err} ->
				{AccAttrs, [Err|AccErrors], dict:erase(K, AccSpecs)}
			end
		end, {[], [], Specs}, Values).