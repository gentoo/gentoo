# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

windows_setup_dllhelper() {
	case ${CATEGORY}/${PN} in
	sys-libs/zlib |\
	'')
		# When a package build system does not know about Windows at all,
		# still it can be built for Windows using Gentoo Parity.
		# But as there is another file to install (the real dll),
		# and installation is done using cp, we override cp to
		# additionally copy the dll when the library is copied.
		windows_setup_dllhelper_cp
		;;
	esac
}

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
	find . -name '*.exe' -o -name '*.dll.a' -o -name '*.so' |
	while read f
	do
		f=${f#./}
		case ${f} in
		*.exe)
			if file "./${f}" | grep "GUI" > /dev/null 2>&1; then
				if test ! -f "./${f%.exe}"; then
					einfo "Windows GUI Executable $f will have no symlink."
				fi
			else
				if test ! -f "./${f%.exe}"; then
					ebegin "creating ${f%.exe} -> ${f} for console accessibility."
					eend $(ln -sf "$(basename "${f}")" "./${f%.exe}" && echo 0 || echo 1)
				fi
			fi
			;;
		*.dll.a)
			if test ! -f "./${f%.a}.lib"; then
				ebegin "creating ${f%.a}.lib -> ${f##*/} for libtool linkability"
				eend $(ln -sf "$(basename "${f}")" "./${f%.a}.lib" && echo 0 || echo 1)
			fi
			;;
		*.so)
			if test ! -f "${f%.so}.dll.lib"; then
				ebegin "creating ${f%.so}.dll.lib -> ${f##*/} for libtool linkability"
				eend $(ln -sf "$(basename "${f}")" "./${f%.so}.dll.lib" && echo 0 || echo 1)
			fi
			;;
		esac
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

windows_setup_dllhelper_cp() {
	if ! [[ $(type -P cp) -ef ${T}/dllhelper/cp ]]
	then
		mkdir -p "${T}/dllhelper"
		cat > "${T}/dllhelper/cp" <<'EOCP'
#!/usr/bin/env bash

mysrcs=()
myopts=()
mydest=
force_dest_file_opt=

nextargs=( "$@" )

while [[ $# > 0 ]]
do
	arg=${1}
	shift
	case ${arg} in
	--)
		mysrcs+=( "${@}" )
		break
		;;
	-S)
		myopts+=( "${arg}" ${1+"$1"} )
		${1:+shift}
		;;
	-t)
		mydest="${1-}"
		${1:+shift}
		;;
	-T)
		force_dest_file_opt=${arg}
		;;
	-*)
		myopts+=( "${arg}" )
		;;
	*)
		mysrcs+=( "${arg}" )
		;;
	esac
done

me=${0##*/}
nextPATH=
oIFS=$IFS
IFS=:
for p in ${PATH}
do
	[[ ${p}/${me} -ef ${0} ]] && continue
	nextPATH+=${nextPATH:+:}${p}
done
IFS=${oIFS}

PATH=${nextPATH}

${me} "${nextargs[@]}"
ret=$?
[[ ${ret} == 0 ]] || exit ${ret}

if [[ -z ${mydest} ]]
then
	[[ ${#mysrcs[@]} < 2 ]] && exit 0
	: "${mysrcs[@]}" "${#mysrcs[@]}"
	mydest=${mysrcs[${#mysrcs[@]}-1]}
	unset mysrcs[${#mysrcs[@]}-1]
elif [[ ${#mysrcs[@]} == 0 ]]
then
	exit 0
fi

for src in ${mysrcs[@]}
do
	ret=0
	[[ ${src##*/} != lib*.so* ]] && continue
	for ext in dll pdb
	do
		[[ ${src##*/} == *.${ext} ]] && continue
		[[ -f ${src} && -f ${src}.${ext} ]] || continue
		if [[ -d ${mydest} && ! -n ${force_dest_file_opt} ]]
		then
			# When copying to directory we keep the basename.
			${me} -T "${myopts[@]}" "${src}.${ext}" "${mydest}/${src##*/}.${ext}"
			ret=$?
		elif [[ ${mydest##*/} == ${src##*/} ]]
		then
			# Copy the dll only when we keep the basename.
			${me} -T "${myopts[@]}" "${src}.${ext}" "${mydest}.${ext}"
			ret=$?
		fi
		[[ ${ret} == 0 ]] || exit ${ret}
	done
done

exit 0
EOCP
		chmod +x "${T}/dllhelper/cp"
		PATH="${T}/dllhelper:${PATH}"
	fi
}

if [[ ${EBUILD_PHASE} == 'setup' ]]
then
	windows_setup_dllhelper
fi
