# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

if [[ ${CATEGORY}/${PN} == app-arch/xz-utils
   && ${EBUILD_PHASE} == setup
   && ${CPPFLAGS} == *-isystem*
]]; then
	# During bootstrap-prefix.sh we set CPPFLAGS="-isystem $EPREFIX/usr/include",
	# but on Cygwin xz-utils eventually does use the windres compiler,
	# which fails to understand -isystem.
	# As xz-utils has no need for -isystem here, we can use -I instead.
	CPPFLAGS=${CPPFLAGS//-isystem /-I}
fi

post_pkg_preinst() {
	cygwin-post_pkg_preinst
}

pre_pkg_postinst() {
	cygwin-pre_pkg_postinst
}

post_pkg_prerm() {
	cygwin-post_pkg_prerm
}

cygwin-post_pkg_preinst() {
	cygwin-rebase-post_pkg_preinst
}

cygwin-pre_pkg_postinst() {
	cygwin-rebase-pre_pkg_postinst
}

cygwin-post_pkg_prerm() {
	cygwin-rebase-post_pkg_prerm
}

###############################################################################
# To allow a Windows DLL to reside in memory just once for multiple processes,
# each process needs to be able to map that DLL at the same base address,
# without the need for a dynamic rebase.  However, this requires the DLL's
# base address to be unique across all DLLs potentially loaded into a single
# process.  Hence the PE/COFF binary format allows to define a preferred base
# address for DLLs, but leaves it up to the package manager to maintain that
# base address to be unique across all DLLs related together.
# (Not sure how exactly ASLR plays in here, though.)
#
# Furthermore, for the Cygwin fork, it is crucial that the child process is
# able to reload a DLL at the very same address as in the parent process.
# Having unique preferred base addresses across all related DLLs does help
# here as well.
#
# The Cygwin rebase utility does maintain some database holding the size and
# preferred base address for each DLL, and allows to update a DLL's preferred
# base address to not conflict with already installed DLLs.
#
# As updating the preferred base address for a DLL in use is a bad idea, we
# need to update the base address while the DLL is in staging directory, and
# update the rebase database after merging the DLL to the live file system.
#
# This allows to define a new preferred base address for a DLL that would
# replace an existing one, because during fork we really want to use the
# old version in the child process, which is verified using the preferred
# base address value to be identical in parent and child process.
#
# Otherwise, the new DLL may have identical size and preferred base address
# as the old DLL, and we may not detect a different DLL in the fork child.
#
# For unmerging a DLL: The Cygwin rebase utility does check if a DLL found
# in the database does still exist, removing that database entry otherwise.
###############################################################################

cygwin-rebase-get_pendingdir() {
	echo "var/db/rebase/pending"
}

cygwin-rebase-get_mergeddir() {
	echo "var/db/rebase/merged"
}

cygwin-rebase-get_listname() {
	echo "dlls_${CATEGORY}_${P}${PR:+-}${PR}"
}

cygwin-rebase-get_rebase_program() {
	[[ ${CHOST} == "${CBUILD}" ]] || return 1
	local pfx
	for pfx in "${EPREFIX}" "${BROOT:-${PORTAGE_OVERRIDE_EPREFIX}}"
	do
		[[ -x ${pfx}/usr/bin/rebase ]] || continue
		echo "${pfx}/usr/bin/rebase"
		return 0
	done
	return 1
}

cygwin-rebase-post_pkg_preinst() {
	# Ensure database is up to date for when dlls were merged but
	# subsequent cygwin-rebase-merge-pending was not executed.
	einfo "Cygwin: Merging pending files into rebase database..."
	cygwin-rebase-merge pending
	eend $?

	local listname=$(cygwin-rebase-get_listname)
	local pendingdir=$(cygwin-rebase-get_pendingdir)
	local rebase_program=$(cygwin-rebase-get_rebase_program)

	if [[ ${CATEGORY}/${PN} == 'app-admin/cygwin-rebase' ]]
	then
		local mergeddir=$(cygwin-rebase-get_mergeddir)
		keepdir "/${pendingdir}"
		keepdir "/${mergeddir}"
	fi

	einfo "Cygwin: Rebasing new files..."
	(
		set -e
		cd "${ED}"

		# The list of suffixes is found in the rebaseall script.
		find . -type f \
			'(' -name '*.dll' \
			 -o -name '*.so' \
			 -o -name '*.oct' \
			')' \
		| sed -e "s|^\.|${EPREFIX}|" > "${T}/rebase-filelist"
		[[ "${PIPESTATUS[*]}" == '0 0' ]]

		# Nothing found to rebase in this package.
		[[ -s ${T}/rebase-filelist ]] || exit 0

		mkdir -p "./${pendingdir}"
		cp -f "${T}/rebase-filelist" "./${pendingdir}/${listname}"

		# Without the rebase program, do not perform a rebase.
		[[ ${rebase_program} ]] || exit 0

		sed -ne "/^${EPREFIX//\//\\/}\\//{s|^${EPREFIX}/||;p}" "./${pendingdir}/${listname}" \
		| "${rebase_program}" --verbose --oblivious --database --filelist=-
		[[ "${PIPESTATUS[*]}" == '0 0' ]]
	)
	eend $?
}

cygwin-rebase-pre_pkg_postinst() {
	if [[ ${CATEGORY}/${PN} == 'app-admin/cygwin-rebase' ]]
	then
		einfo "Cygwin: Updating rebase database with installed files..."
		cygwin-rebase-merge merged
		eend $?
	fi
	einfo "Cygwin: Merging updated files into rebase database..."
	cygwin-rebase-merge pending
	eend $?
}

cygwin-rebase-merge() {
	local mode=${1}

	local rebase_program=$(cygwin-rebase-get_rebase_program)
	[[ ${rebase_program} ]] || return 0

	local pendingdir=''
	local mergeddir=''
	case ${mode} in
	pending)
		pendingdir=$(cygwin-rebase-get_pendingdir)
		mergeddir=$(cygwin-rebase-get_mergeddir)
		;;
	merged)
		pendingdir=$(cygwin-rebase-get_mergeddir)
		mergeddir=''
		;;
	*)
		die "Invalid mode '${mode}'."
		;;
	esac

	(
		set -e
		cd "${EROOT}"

		[[ -r ./${pendingdir}/. ]]
		[[ -r ./${mergeddir}/. ]]

		find ./"${pendingdir}" -mindepth 1 -maxdepth 1 -type f -name 'dlls_*' \
			-exec sed -ne "/^${EPREFIX//\//\\/}\\//{s|^${EPREFIX}/||;p}" {} + \
			| "${rebase_program}" --verbose --merge-files --database --filelist=-
		[[ "${PIPESTATUS[*]}" == '0 0' ]]

		[[ ${mode} == 'pending' ]] || exit 0

		find "./${pendingdir}" -mindepth 1 -maxdepth 1 -type f -name 'dlls_*' \
			-exec mv -f -t "./${mergeddir}/" {} +
	)
	[[ $? == 0 ]] || die "Merging ${mode} files into rebase database failed."
}

cygwin-rebase-post_pkg_prerm() {
	# The pending list is registered as being installed with the package, but
	# the merged list is not.  Just remove the unregistered one.
	local mergeddir=$(cygwin-rebase-get_mergeddir)
	local listname=$(cygwin-rebase-get_listname)
	(
		set -e
		cd "${EROOT}"
		[[ -w ./${mergeddir}/. ]]
		rm -f "./${mergeddir}/${listname}"
	)
}
