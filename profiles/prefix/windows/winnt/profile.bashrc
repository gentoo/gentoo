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

#######################################################################
#
# Unix aware build tools may provide (e.g. pkg-config) and accept
# (e.g. gcc) the -lNAME linker option.  While they create libNAME.so
# as the import library, they may be unaware of the additional dll.
# The dllhelper wrappers take care of copying the real dll when
# copying the libNAME.so.
#
# Cygwin and MinGW aware build tools may create the import library
# as libNAME.dll.a or libNAME.dll.lib, and are aware of the dll,
# while a subsequent linker step still receives the -lNAME option.
#
# MSVC aware build tools may provide (e.g. icu-config) and accept
# (e.g. cl.exe) the NAME.lib linker option, maybe with full path,
# and are aware of the dll.
#
# Libtool does accept both the Unix and MSVC variants now, but does
# search for the libNAME(.la|.dll|.so|.a) file upon -lNAME, in order.
#
# As Gentoo ebuilds may remove libNAME.la, we need the libNAME.so
# because we don't want to have libNAME.dll as an import library.
#
# Here, for whatever import library name we find, make sure there
# is both the NAME.lib and the libNAME.so for linkability via both
# the -lNAME and the NAME.lib linker option.
#
#######################################################################

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
	cd "${ED}" || return 0
	#
	# File names being treated as import library:
	#  libNAME.so
	#     NAME.lib
	#  libNAME.dll.lib
	#  libNAME.dll.a
	#
	# File names being ignored as static library:
	#  libNAME.lib
	#  libNAME.a
	#
	# File names being warned about as suspect:
	#     NAME.so
	#     NAME.a
	#     NAME.dll.lib
	#     NAME.dll.a
	#
	find . -name '*.so' -o -name '*.lib' -o -name '*.a' |
	while read f
	do
		f=${f#./}
		libdir=$(dirname "${f}")
		libfile=${f##*/}
		libname=
		case ${libfile} in
		lib.so) ;; # paranoia
		lib*.so)
			libname=${libfile%.so}
			libname=${libname#lib}
			;;
		lib.dll.lib) ;; # paranoia
		lib*.dll.lib)
			libname=${libfile%.dll.lib}
			libname=${libname#lib}
			;;
		lib.lib) ;; # paranoia
		lib*.lib) continue ;; # ignore static library
		.lib) ;; # paranoia
		*.lib)
			libname=${libfile%.lib}
			;;
		lib.dll.a) ;; # paranoia
		lib*.dll.a)
			libname=${libfile%.dll.a}
			libname=${libname#lib}
			;;
		lib.a) ;; # paranoia
		lib*.a) continue ;; # ignore static library
		esac
		if [[ -z ${libname} ]]; then
			ewarn "Ignoring suspect file with library extension: ${f}"
			continue
		fi

		NAMElib=${libname}.lib
		libNAMEso=lib${libname}.so
		if [[ ! -e ./${libdir}/${NAMElib} ]]; then
			ebegin "creating ${NAMElib} copied from ${f##*/} for MSVC linkability"
			cp -pf "./${libdir}/${libfile}" "./${libdir}/${NAMElib}" || die
			eend $?
		fi
		if [[ ! -e "./${libdir}/${libNAMEso}" ]]; then
			ebegin "creating ${libNAMEso} symlink to ${f##*/} for libtool linkability"
			ln -sf "${libfile}" "./${libdir}/${libNAMEso}" || die
			eend $?
		fi
	done
	[[ -d usr/$(get_libdir) ]] &&
	find usr/$(get_libdir) -maxdepth 1 -type f -name '*.dll' |
	while read f
	do
		if [[ ! -f usr/bin/${f##*/} ]]; then
			ebegin "moving ${f} to usr/bin for native loader"
			dodir usr/bin || die
			mv -f "${f}" usr/bin/ || die
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
