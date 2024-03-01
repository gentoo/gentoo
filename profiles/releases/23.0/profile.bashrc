if [[ "${EBUILD_PHASE}" == "setup" ]] ; then
	if [[ ! -h "${EROOT%/}/bin" ]] && [[ "${PROFILE_23_USRTYPE}" != "split-usr" ]] ; then
		eerror ""
		eerror "Your profile is of type merged-usr, but your directories"
		eerror "on-disk are of type split-usr."
		eerror "Please switch back to your last valid profile setting and"
		eerror "read the documentation about merged-usr and profile changes."
		eerror ""
		die "ERROR: 23.0 merged-usr profile, but disk is split-usr"
	fi
	if [[ -h "${EROOT%/}/bin" ]] && [[ "${PROFILE_23_USRTYPE}" == "split-usr" ]] ; then
		eerror ""
		eerror "Your profile is of type split-usr, but your directories"
		eerror "on-disk are of type merged-usr."
		eerror "Please switch back to your last valid profile setting and"
		eerror "read the documentation about merged-usr and profile changes."
		eerror ""
		die "ERROR: 23.0 split-usr profile, but disk is merged-usr"
	fi
fi
