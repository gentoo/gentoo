if [[ -L ${ROOT%/}/lib || -L ${ROOT%/}/usr/lib ]] ; then
	eerror "Please follow the instructions in the news item:"
	eerror "2017-12-26-experimental-amd64-17-1-profiles"
	eerror "or choose the 17.0 profile."
	die "ERROR: 17.1 migration has not been performed!!"
fi

