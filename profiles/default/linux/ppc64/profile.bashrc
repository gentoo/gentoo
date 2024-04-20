if [[ "${EBUILD_PHASE}" == "setup" ]] ; then
	if [[ "$(realpath ${ROOT%/}/lib)" == "${ROOT%/}/lib64" || "$(realpath ${ROOT%/}/usr/lib)" == "${ROOT%/}/usr/lib64" ]] ; then
		eerror "Please follow the instructions in the news item:"
		eerror "2021-07-17-new-ppc64-profiles"
		eerror "or choose the old profile in"
		eerror "default/linux/powerpc/ppc64 structure"
		die "ERROR: SYMLINK_LIB migration has not been performed!!"
	fi
fi
