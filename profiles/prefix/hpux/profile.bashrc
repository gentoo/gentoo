# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# /bin/sh is korn shell, incompatible with bash used by makefiles later.
# This is a problem with recent libtool detecting non-bashism 'print' fex.
export CONFIG_SHELL=${BASH}

# On hpux, binary files (executables, shared libraries) in use
# cannot be replaced during merge.
# But it is possible to rename them and remove lateron when they are
# not used any more by any running process.
#
# This is a workaround for portage bug#199868,
# and should be dropped once portage does sth. like this itself.

hpux-busytext-get-listfile() {
	echo "${ROOT%%/}${EPREFIX}/var/lib/portage/files2bremoved"
}

hpux-busytext-cleanup() {
	local removedlist=$(hpux-busytext-get-listfile)

	rm -f "${removedlist}".new

	if [[ -r ${removedlist} ]]; then
		rm -f "${removedlist}".old
	fi
	# restore in case of system fault
	if [[ -r ${removedlist}.old ]]; then
		mv "${removedlist}"{.old,}
	fi

	touch "${removedlist}"{,.new} # ensure they exist

	local rmstem f
	while read rmstem
	do
		# try to remove previously recorded files
		for f in $(ls "${ROOT}${rmstem}"*); do
			echo "trying to remove old busy text file ${f}"
			rm -f "${f}"
		done
		# but keep it in list if still exists
		for f in $(ls "${ROOT}${rmstem}"*); do
			echo "${rmstem}" >> "${removedlist}".new
			break
		done
	done < "${removedlist}"

	# update the list
	mv "${removedlist}"{,.old}
	mv "${removedlist}"{.new,}
	rm "${removedlist}".old
}

hpux-busytext-backup() {
	local removedlist=$(hpux-busytext-get-listfile)

	# now go for current package
	cd "${D}" || exit 1

	/usr/bin/find ".${EPREFIX}" '!' -type d \
	| while read f
	  do
		  f=${f#./}
		  [[ ! -f ${ROOT}${f} || -h ${ROOT}${f} ]] && continue
		  echo "${ROOT}${f}"
	  done \
	  | xargs -r /usr/bin/file \
	  | /usr/bin/grep -E '(object file|shared library|executable)' \
	  | while read f t
		do
			# file prints: "file-argument: type-of-file"
			f=${f#${ROOT}}
			f=${f%:}
			test -r "${ROOT}${f}" || continue
			rmstem="${f}.removedbyportage"
			# keep list of old busy text files unique
			/usr/bin/grep "^${rmstem/[/\\[}$" "${removedlist}" >/dev/null \
			|| echo "${rmstem}" >> "${removedlist}"
			n=0
			while [[ ${n} -lt 100 && -f "${ROOT}${rmstem}${n}" ]]; do
				n=$((n=n+1))
			done

			if [[ ${n} -ge 100 ]]; then
				echo "too many (>=100) old text files busy of '${ROOT}${f}'" >&2
				exit 1
			fi
			echo "backing up text file ${ROOT}${f} (${n})"
			/usr/bin/mv -f "${ROOT}${f}" "${ROOT}${rmstem}${n}" || exit 1
			/usr/bin/cp -f "${ROOT}${rmstem}${n}" "${ROOT}${f}" || exit 1
		done || exit 1
}

prefix_hpux-post_pkg_preinst() {
	hpux-busytext-cleanup
	hpux-busytext-backup
}

prefix_hpux-pre_pkg_postinst() {
	hpux-busytext-cleanup
}

# These are because of
# http://archives.gentoo.org/gentoo-dev/msg_529a0806ed2cf841a467940a57e2d588.xml
# The profile-* ones are meant to be used in etc/portage/profile.bashrc by user
# until there is the registration mechanism.
profile-post_pkg_preinst() { prefix_hpux-post_pkg_preinst ; }
        post_pkg_preinst() { prefix_hpux-post_pkg_preinst ; }

profile-pre_pkg_postinst() { prefix_hpux-pre_pkg_postinst ; }
        pre_pkg_postinst() { prefix_hpux-pre_pkg_postinst ; }
