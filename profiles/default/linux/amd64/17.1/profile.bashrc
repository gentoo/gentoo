# Skip unmerge phases. Don't name a phase here: Portage would
# serialize it for every package.
if [[ "${EBUILD_PHASE}" != *rm ]] ; then
	if [[ "$(realpath ${ROOT%/}/lib)" == "${ROOT%/}/lib64" || "$(realpath ${ROOT%/}/usr/lib)" == "${ROOT%/}/usr/lib64" ]] ; then
		eerror "Please follow the instructions in the news item:"
		eerror "2019-06-05-amd64-17-1-profiles-are-now-stable"
		eerror "or choose the 17.0 profile."
		die "ERROR: 17.1 migration has not been performed!!"
	fi
fi

