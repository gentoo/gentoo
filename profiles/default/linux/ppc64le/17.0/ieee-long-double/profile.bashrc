if [[ "${EBUILD_PHASE}" == "setup" ]] ; then
        if [[ ${CATEGORY}/${PN} != sys-devel/gcc ]]; then
                if [[ $(${CC:-cc} -E -dM - < /dev/null | grep -o '__LDBL_MANT_DIG__ .*') != "__LDBL_MANT_DIG__ 113" ]]; then
			eerror
                        eerror "${CC:-cc} should provide ieee-long-double on this profile by default"
                        eerror "reinstall sys-devel/gcc with USE=ieee-long-double and try again."
			eerror
			die "install >=sys-devel/gcc-12[ieee-long-double]"
                fi
        fi
fi
