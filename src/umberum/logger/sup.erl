%% --------------------------
%% @copyright 2012 Bob.sh Limited
%% @doc Supervisor module for Umberum Logger
%% 
%% @end
%% --------------------------

-module(umberum.logger.sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

%% @doc Start and link to this module
start_link() ->
    .supervisor:start_link(.umberum.logger.sup, []).

-define(MAX_RESTART,    5).
-define(MAX_TIME,      60).

init(_Args) ->
    {ok,
        {_SupFlags = {one_for_one, ?MAX_RESTART, ?MAX_TIME},
            [
                % RELP Listener
                {   .umberum.logger.relp.relp_sup,           % Id       = internal id
                  {.umberum.logger.relp.relp_sup,start_link,[]}, % StartFun = {M, F, A}
                  permanent,                               % Restart  = permanent | transient | temporary
                  infinity,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
                  supervisor,                                  % Type     = worker | supervisor
                  [.umberum.logger.relp.relp_sup]          % Modules  = [Module] | dynamic
                },
                % Syslog supervisor
                {   umberum.logger.syslog_3164.decode_sup,
                  {.umberum.logger.syslog_3164.decode_sup,start_link,[]},
                  permanent,                               % Restart  = permanent | transient | temporary
                  infinity,                                % Shutdown = brutal_kill | int() >= 0 | infinity
                  supervisor,                              % Type     = worker | supervisor
                  []                                       % Modules  = [Module] | dynamic
                },
                % Route supervisor
                {   umberum.logger.route.route_sup,
                  {.umberum.logger.route.route_sup,start_link,[]},
                  permanent,                               % Restart  = permanent | transient | temporary
                  infinity,                                % Shutdown = brutal_kill | int() >= 0 | infinity
                  supervisor,                              % Type     = worker | supervisor
                  []                                       % Modules  = [Module] | dynamic
                },
	            % File writer
                {   umberum.logger.file.writer_sup,
                  {.umberum.logger.file.writer_sup,start_link,[]},
                  permanent,                               % Restart  = permanent | transient | temporary
                  infinity,                                % Shutdown = brutal_kill | int() >= 0 | infinity
                  supervisor,                              % Type     = worker | supervisor
                  []                                       % Modules  = [Module] | dynamic
                },
	            % Mongodb writer
                {   umberum.logger.mongodb.writer_sup,
                  {.umberum.logger.mongodb.writer_sup,start_link,[]},
                  permanent,                               % Restart  = permanent | transient | temporary
                  infinity,                                % Shutdown = brutal_kill | int() >= 0 | infinity
                  supervisor,                              % Type     = worker | supervisor
                  []                                       % Modules  = [Module] | dynamic
                }
            ]
         }
    }.
