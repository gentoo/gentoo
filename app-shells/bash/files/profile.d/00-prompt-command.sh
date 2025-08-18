# This unit serves to initialise PROMPT_COMMAND as early as possible in cases
# where bash has been launched as a login shell. Though not an especially
# common practice, some profile.d drop-ins need to be able to extend its value.

if [ "${BASH}" ] && shopt -q login_shell; then
	eval 'PROMPT_COMMAND=()'
fi
