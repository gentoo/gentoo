
__gentoo_get_disk_splitmerge() {
	# does /bin exist? important for baselayout
	if [[ -e "${EROOT%/}/bin" ]] ; then
		# is /bin a symlink?
		if [[ -h "${EROOT%/}/bin" ]] ; then
			echo -n merged
		else
			echo -n split
		fi
	else
		echo -n unknown
	fi
}

__gentoo_get_profile_splitmerge() {
	# does /etc/portage/make.profile exist and is a symlink?
	if [[ -h "${EROOT%/}/etc/portage/make.profile" ]] ; then
		local linktarget=$(readlink "${EROOT%/}/etc/portage/make.profile")

		# 23.0 profile?
		if [[ "${linktarget}" == */23.0* ]] ; then
			if [[ "${linktarget}" == *split-usr* ]] ; then
				echo -n split
			else
				echo -n merged
			fi
		else
			echo -n unknown
		fi
	else
		echo -n unknown
	fi
}

if [[ "${EBUILD_PHASE}" == "setup" ]] ; then
	if [[ $(__gentoo_get_disk_splitmerge) == "split" ]] && [[ $(__gentoo_get_profile_splitmerge) == "merged" ]] ; then
		eerror ""
		eerror "Your profile is of type merged-usr, but your directories"
		eerror "on-disk are of type split-usr."
		eerror "Please switch back to your last valid profile setting and"
		eerror "read the documentation about merged-usr and profile changes."
		eerror ""
		die "ERROR: 23.0 merged-usr profile, but disk is split-usr"
	fi
	if [[ $(__gentoo_get_disk_splitmerge) == "merged" ]] && [[ $(__gentoo_get_profile_splitmerge) == "split" ]] ; then
		eerror ""
		eerror "Your profile is of type split-usr, but your directories"
		eerror "on-disk are of type merged-usr."
		eerror "Please switch back to your last valid profile setting and"
		eerror "read the documentation about merged-usr and profile changes."
		eerror ""
		die "ERROR: 23.0 split-usr profile, but disk is merged-usr"
	fi
fi

unset -f __gentoo_get_disk_splitmerge __gentoo_get_profile_splitmerge
