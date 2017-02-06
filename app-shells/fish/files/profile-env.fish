# only apply env for login shells, as we'd like fish to
# inherit existing shell environment without overriding it
# using csh env, as it's cleaner and less too parse/strip

if status --is-login
	# since fish supports export via upstream provided function
	# we can source directly, only ommiting $PATH and comments.
	string match -r -v '^(#|setenv (PATH|ROOTPATH) )' < /etc/csh.env | source

	# strip unneded stuff from setenv lines
	# apply paths and cleanup
	if [ "$EUID" = "0" ] ; or [ "$USER" = "root" ]
		string match -r '^setenv ROOTPATH .+' < /etc/csh.env | string replace -ra '\'|\:' ' ' | source
		set -gx PATH /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin $ROOTPATH
		set -e ROOTPATH
	else
		string match -r '^setenv PATH .+' < /etc/csh.env | string replace -ra '\'|\:' ' ' | source
		set -gx PATH /usr/local/bin /usr/bin /bin $PATH
	end

	# re-prepend $fish_user_paths
	__fish_reconstruct_path
end
