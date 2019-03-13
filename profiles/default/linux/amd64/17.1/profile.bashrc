if [[ "${EBUILD_PHASE}" == "setup" ]] ; then
	if [[ "$(realpath ${ROOT%/}/lib)" == "${ROOT%/}/lib64" || "$(realpath ${ROOT%/}/usr/lib)" == "${ROOT%/}/usr/lib64" ]] ; then
		eerror "Please follow the instructions in the news item:"
		eerror "2017-12-26-experimental-amd64-17-1-profiles"
		eerror "or choose the 17.0 profile."
		die "ERROR: 17.1 migration has not been performed!!"
	fi
fi

