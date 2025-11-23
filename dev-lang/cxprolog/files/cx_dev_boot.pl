'$cxprolog_initialise' :-
	version,
	fs_cwd(CWD),
	fs_set_prefix_dir(CWD),
	'$env_context' := [main].


'$cxprolog_top_level_goal' :-
	true.
