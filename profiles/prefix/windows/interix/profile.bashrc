# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/profiles/prefix/windows/interix/profile.bashrc,v 1.5 2010/10/22 07:30:09 mduft Exp $

# use bash as config shell. this avoids _big_ problems with new libtool (>=2.2.10),
# as wrong asumptions about the shell arise when checking against /bin/sh.
export CONFIG_SHELL=${BASH}

# On interix, binary files (executables, shared libraries) in use
# cannot be replaced during merge.
# But it is possible to rename them and remove lateron when they are
# not used any more by any running program.
#
# This is a workaround for portage bug#199868,
# and should be dropped once portage does sth. like this itself.

interix_cleanup_removed_files() {
	local removedlist=$1
	rm -f "${removedlist}".new

	if [[ -r ${removedlist} ]]; then
		rm -f "${removedlist}".old
	fi
	# restore in case of system fault
	if [[ -r ${removedlist}.old ]]; then
		mv "${removedlist}"{.old,}
	fi

	touch "${removedlist}"{,.new} # ensure they exist

	while read rmstem; do
		# try to remove previously recorded files
		for f in "${ROOT}${rmstem}"*; do
			ebegin "trying to remove ${f}"
			rm -f "${f}" > /dev/null 2>&1
			eend $?
		done
		# but keep it in list if still exists
		for f in "${ROOT}${rmstem}"*; do
			[[ -f ${f} ]] && echo "${rmstem}" >> "${removedlist}".new
			break
		done
	done < "${removedlist}"

	# update the list
	mv "${removedlist}"{,.old}
	mv "${removedlist}"{.new,}
	rm "${removedlist}".old
}

interix_find_removed_slot() {
	local f=$1
	local n=0
	while [[ ${n} -lt 100 && -f "${f}${n}" ]]; do
		n=$((n=n+1))
	done

	if [[ ${n} -ge 100 ]]; then
		echo "too many (>=100) old text files busy of '${f}'" >&2
		exit 1
	fi

	echo $n
}

interix_prepare_file() {
	local failed=0
	if [[ ${PN} == libiconv ]]; then
		# when moving around libiconv, the prefix' coreutils will
		# be damaged, so we really need to use the systems ones.
		/bin/cp -p "${1}" "${1}.new" || failed=1
		/bin/mv "${1}" "${2}" || failed=1
		/bin/mv "${1}.new" "${1}" || failed=1
	else
		my_mv=mv

		[[ "${1}" == */mv ]] && my_mv="${1}.new"
		[[ -f "${1}.new" ]] && rm -f "${1}.new"

		cp -p "${1}" "${1}.new" || failed=1
		${my_mv} "${1}" "${2}" || failed=1
		${my_mv} "${1}.new" "${1}" || failed=1
	fi

	echo $failed
}

post_pkg_preinst() {
	local removedlist="${EROOT}var/lib/portage/files2bremoved"
	interix_cleanup_removed_files $removedlist
	
	# now go for current package
	cd "${D}"
	find ".${EROOT}" -type f | while read f;
	do
		/usr/bin/file "${f}" | grep ' PE ' > /dev/null || continue

		f=${f#./} # find prints: "./path/to/file"
		f=${f%:} # file prints: "file-argument: type-of-file"
		test -r "${ROOT}${f}" || continue
		rmstem="${f}.removedbyportage"
		# keep list of old busy text files unique
		grep -Fx "${rmstem}" "${removedlist}" >/dev/null \
			|| echo "${rmstem}" >> "${removedlist}"

		local n=$(interix_find_removed_slot ${ROOT}${rmstem})
		ebegin "preparing ${ROOT}${f} for merge (${n})"
		eend $(interix_prepare_file "${ROOT}${f}" "${ROOT}${rmstem}${n}")
	done
}

post_pkg_prerm() {
	local removedlist="${EROOT}var/lib/portage/files2bremoved"
	save_IFS=$IFS
	IFS='
';
	local MY_PR=${PR}
	[[ ${MY_PR} == r0 ]] && MY_PR=
	local -a contents=($(<"${EROOT}var/db/pkg/${CATEGORY}/${P}${MY_PR:+-}${MY_PR}/CONTENTS"));
	IFS=$save_IFS
	local -a cont
	for content in "${contents[@]}"; do
		cont=($content)
		f=${cont[1]}
		f=${f#/}

		test -r "${ROOT}${f}" || continue

		if /usr/bin/file "${ROOT}${f}" | grep ' PE ' > /dev/null; then
			# $f should be an absolute path to the installed file
			rmstem="${f}.removedbyportage"

			grep "^${rmstem}$" "${removedlist}" > /dev/null \
				|| echo "${rmstem}" >> "${removedlist}"

			local n=$(interix_find_removed_slot ${ROOT}${rmstem})
			ebegin "preparing ${ROOT}${f} for unmerge ($n)"
			eend $(interix_prepare_file "${ROOT}${f}" "${ROOT}${rmstem}${n}")
		fi
	done
}

pre_pkg_postrm() {
	local removedlist="${EROOT}var/lib/portage/files2bremoved"
	interix_cleanup_removed_files $removedlist
}
