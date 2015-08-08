# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# On windows, binary files (executables, shared libraries) in use
# cannot be replaced during merge.
# But it is possible to rename them and remove lateron when they are
# not used any more by any running program.
#
# This is a workaround for portage bug#199868,
# and should be dropped once portage does sth. like this itself.
#

# Need to explicitly set PKG_CONFIG_PATH for cross EPREFIX.
export PKG_CONFIG_PATH="${EPREFIX}/lib/pkgconfig:${EPREFIX}/usr/lib/pkgconfig"

windows_cleanup_removed_files() {
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

windows_find_removed_slot() {
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

windows_prepare_file() {
	local failed=0
	my_mv=mv

	[[ "${1}" == */mv ]] && my_mv="${1}.new"
	[[ -f "${1}.new" ]] && rm -f "${1}.new"

	cp -p "${1}" "${1}.new" || failed=1
	${my_mv} "${1}" "${2}" || failed=1
	${my_mv} "${1}.new" "${1}" || failed=1

	echo $failed
}

post_src_install() {
	cd "${ED}"
	find . -name '*.exe' | while read f; do
		if file "${f}" | grep "GUI" > /dev/null 2>&1; then
			if test ! -f "${f%.exe}"; then
				einfo "Windows GUI Executable $f will have no symlink."
			fi
		else
			if test ! -f "${f%.exe}"; then
				ebegin "creating ${f%.exe} -> ${f} for console accessibility."
				eend $(ln -sf "$(basename "${f}")" "${f%.exe}" && echo 0 || echo 1)
			fi
		fi
	done
}

post_pkg_preinst() {
	local removedlist="${EROOT}var/lib/portage/files2bremoved"
	windows_cleanup_removed_files $removedlist
	
	# now go for current package
	cd "${D}"
	find ".${EROOT}" -type f | xargs -r /usr/bin/file | grep ' PE ' | while read f t
	do
		f=${f#./} # find prints: "./path/to/file"
		f=${f%:} # file prints: "file-argument: type-of-file"
		test -r "${ROOT}${f}" || continue
		rmstem="${f}.removedbyportage"
		# keep list of old busy text files unique
		grep "^${rmstem}$" "${removedlist}" >/dev/null \
			|| echo "${rmstem}" >> "${removedlist}"

		local n=$(windows_find_removed_slot ${ROOT}${rmstem})
		ebegin "backing up text file ${ROOT}${f} (${n})"
		eend $(windows_prepare_file "${ROOT}${f}" "${ROOT}${rmstem}${n}")
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

			local n=$(windows_find_removed_slot ${ROOT}${rmstem})
			ebegin "preparing ${ROOT}${f} for unmerge ($n)"
			eend $(windows_prepare_file "${ROOT}${f}" "${ROOT}${rmstem}${n}")
		fi
	done
}

pre_pkg_postrm() {
	local removedlist="${EROOT}var/lib/portage/files2bremoved"
	windows_cleanup_removed_files $removedlist
}
