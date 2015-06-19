if [[ ${EBUILD_PHASE} == "setup" ]] ; then

	# on x86, -pg requires the frame pointer, so turning it off makes no sense
	if has profile ${IUSE} && use profile && \
	   has -fomit-frame-pointer ${CFLAGS} ${CXXFLAGS}
	then
		eerror "\nUSE=profile and -fomit-frame-pointer make no sense"
		eerror "Fix your build settings to avoid build failures\n"
		[[ -z ${EPAUSE_IGNORE} ]] && sleep 5
	fi

fi
