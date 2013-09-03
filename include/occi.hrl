%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2013, Jean Parpaillon
%%% @doc Created from https://github.com/dizz/occi-grammar/blob/master/occi-antlr-grammar/Occi.g
%%%
%%% @end
%%% Created : 14 Mar 2013 by Jean Parpaillon <jean.parpaillon@free.fr>
-type(uri() :: binary() | list()).
-type(occi_class() :: kind | mixin | action).
-type(occi_property() :: required | immutable).
-type(occi_attr_spec() :: {occi_attribute, atom(), [occi_property()], term()}).
-type(occi_action_spec() :: term()).

%%% OCCI Category ID
-record(occi_cid, {scheme    = undefined :: atom(),
		   term      = undefined :: atom(),
		   class                 :: occi_class()}).
-type(occi_cid() :: #occi_cid{}).

%%% OCCI Kind
-record(occi_kind, {id         = #occi_cid{}  :: occi_cid(),
		    title      = undefined    :: binary(),
		    attributes = []           :: [occi_attr_spec()],
		    rel        = []           :: uri(),
		    actions    = []           :: [occi_action_spec()],
		    location                  :: uri()}).
-type(occi_kind() :: #occi_kind{}).

%%% OCCI Mixin
-record(occi_mixin, {id         = #occi_cid{}  :: occi_cid(),
		     title      = undefined    :: binary(),
		     attributes = []           :: [occi_attr_spec()],
		     actions    = []           :: [occi_action_spec()],
		     location                  :: uri()}).
-type(occi_mixin() :: #occi_mixin{}).

%%% OCCI Action
-record(occi_action, {id         = #occi_cid{}  :: occi_cid(),
		      title      = undefined    :: binary(),
		      attributes = []           :: [occi_attr_spec()]}).
-type(occi_action() :: #occi_action{}).

%%% OCCI Category
-type(occi_category() :: occi_kind() | occi_mixin() | occi_action()).

%%% OCCI Entity
-type(occi_entity_id() :: any()).

-record(occi_entity, {id         = undefined :: occi_entity_id(),
		      module                 :: atom(),
		      title      = undefined :: binary(),
		      attributes             :: [{atom(), any()}]}).
-type(occi_entity() :: #occi_entity{}).

%%% OCCI Resource
-record(occi_resource, {id         = undefined :: occi_entity_id(),
			cid                    :: occi_cid(),
			location   = undefined :: uri(),
			title      = undefined :: binary(),
		        summary    = undefined :: binary(),
			attributes = []        :: [{atom(), any()}],
			links      = []        :: [uri()],
			mixins     = []        :: [occi_cid()]}).
-type(occi_resource() :: #occi_resource{}).

%%% OCCI Link
-record(occi_link, {id         = undefined :: occi_entity_id(),
		    cid                    :: occi_cid(),
		    location   = undefined :: uri(),
		    title      = undefined :: binary(),
		    attributes = []        :: [{atom(), any()}],
		    source                 :: uri(),
		    target                 :: uri(),
		    mixins     = []        :: [occi_cid()]}).
-type(occi_link() :: #occi_link{}).

%%% OCCI

%%% OCCI Filter
-type(occi_filter() :: any()).