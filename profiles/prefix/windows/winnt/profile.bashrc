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
		ebegin "Setting up wrapper to copy the DLL along the LIB"
		windows_setup_dllhelper_cp
		eend $?
		;;
	esac
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
	[[ -d usr/$(get_libdir) ]] &&
	find usr/$(get_libdir) -maxdepth 1 -type f -name '*.dll' |
	while read f
	do
		if test ! -f usr/bin/${f##*/}; then
			ebegin "moving ${f} to usr/bin for native loader"
			dodir usr/bin || die
			mv -f "${f}" usr/bin || die
			ln -sf "../bin/${f##*/}" "${f}" || die
			eend $?
		fi
	done
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
