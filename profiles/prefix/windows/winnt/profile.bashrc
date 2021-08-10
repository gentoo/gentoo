# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# On windows, binary files (executables, shared libraries) in use
# cannot be replaced during merge.
# But it is possible to rename them and remove lateron when they are
# not used any more by any running program.
#
# This is a workaround for portage bug#199868,
# and should be dropped once portage does sth. like this itself.
#

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
# The static library may be created as libNAME.a, libNAME.lib or even
# NAME.lib - the latter we need to check for static or import library.
#
# For whatever import library file we find, make sure there is both the
# NAME.lib and the libNAME.so for dynamic linkability via all the
# -lNAME, the NAME.lib and the libNAME.so linker option.
#
# For whatever static library file we find, make sure there is both the
# libNAME.lib and the libNAME.a for static linkability via all the
# -lNAME, the libNAME.lib and the libNAME.a linker option.
#
#######################################################################

winnt_setup_dllhelper() {
	case ${CATEGORY}/${PN} in
	sys-libs/zlib |\
	'')
		# When a package build system does not know about Windows at all,
		# still it can be built for Windows using Gentoo Parity.
		# But as there is another file to install (the real dll),
		# and installation is done using cp, we override cp to
		# additionally copy the dll when the library is copied.
		ebegin "Setting up wrapper to copy the DLL along the LIB"
		winnt_setup_dllhelper_cp
		eend $?
		;;
	esac
}

post_src_install() {
	winnt_post_src_install
}

winnt_post_src_install() {
	cd "${ED}" || return 0
	#
	# File names being treated as import library:
	#  libNAME.so
	#     NAME.lib if CHOST-dumpbin yields 'DLL name'
	#  libNAME.dll.lib
	#  libNAME.dll.a
	#
	# File names being treated as static library:
	#  libNAME.lib
	#     NAME.lib if CHOST-dumpbin lacks 'DLL name'
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
		NAMElib=    # import lib to create
		libNAMEso=  # import lib to create
		libNAMElib= # static lib to create
		libNAMEa=   # static lib to create
		case ${libfile} in
		lib*.so) # found import library
			libname=${libfile%.so}
			libname=${libname#lib}
			NAMElib=${libname}.lib
			libNAMEso=lib${libname}.so
			;;
		*.so) ;; # warn
		lib*.dll.lib) # found import library
			libname=${libfile%.dll.lib}
			libname=${libname#lib}
			NAMElib=${libname}.lib
			libNAMEso=lib${libname}.so
			;;
		*.dll.lib) ;; # warn
		*.lib) # found static or import library
			${CHOST}-dumpbin.exe /headers "./${libdir}/${libfile}" | grep -q 'DLL name'
			case "${PIPESTATUS[*]}" in
			'0 0') # found import library
				libname=${libfile%.lib}
				libname=${libname#lib}
				NAMElib=${libname}.lib
				libNAMEso=lib${libname}.so
				;;
			'0 1') # found static library
				libname=${libfile%.lib}
				libname=${libname#lib}
				libNAMEa=lib${libname}.a
				libNAMElib=lib${libname}.lib
				;;
			*)
				die "Cannot run ${CHOST}-dumpbin on ${libdir}/${libfile}"
				;;
			esac
			;;
		lib*.dll.a) # found import library
			libname=${libfile%.dll.a}
			libname=${libname#lib}
			NAMElib=${libname}.lib
			libNAMEso=lib${libname}.so
			;;
		*.dll.a) ;; # warn
		lib*.a) # found static library
			libname=${libfile%.a}
			libname=${libname#lib}
			libNAMEa=lib${libname}.a
			libNAMElib=lib${libname}.lib
			;;
		*.a) ;; # warn
		esac
		if [[ -z ${libname} ]]; then
			ewarn "Ignoring suspect file with library extension: ${f}"
			continue
		fi

		if [[ ${NAMElib} && ! -e ./${libdir}/${NAMElib} ]]; then
			ebegin "creating ${NAMElib} from ${libfile} for MSVC linkability"
			cp -pf "./${libdir}/${libfile}" "./${libdir}/${NAMElib}" || die
			eend $?
		fi
		if [[ ${libNAMElib} && ! -e ./${libdir}/${libNAMElib} ]]; then
			ebegin "creating ${libNAMElib} from ${libfile} for MSVC linkability"
			cp -pf "./${libdir}/${libfile}" "./${libdir}/${libNAMElib}" || die
			eend $?
		fi
		if [[ ${libNAMEso} && ! -e ./${libdir}/${libNAMEso} ]]; then
			ebegin "creating ${libNAMEso} from ${f##*/} for POSIX linkability"
			cp -pf "./${libdir}/${libfile}" "./${libdir}/${libNAMEso}" || die
			eend $?
		fi
		if [[ ${libNAMEa} && ! -e ./${libdir}/${libNAMEa} ]]; then
			ebegin "creating ${libNAMEa} from ${f##*/} for POSIX linkability"
			cp -pf "./${libdir}/${libfile}" "./${libdir}/${libNAMEa}" || die
			eend $?
		fi
	done
	if [[ -d usr/$(get_libdir) ]]
	then
		# The native loader does not understand symlinks to dlls,
		# seen to be created by dev-libs/icu eventually.  For any
		# dll we find in usr/lib we need to perform a real copy to
		# usr/bin, to resolve potential symlinks (seen from icu),
		# and perform the remove from usr/lib afterwards, to not
		# break symlinks later on discovered by find.
		local toremove=()
		local f
		while read f
		do
			[[ -f usr/bin/${f##*/} ]] && continue
			ebegin "moving ${f} to usr/bin for the native loader"
			dodir usr/bin || die
			cp -f "${f}" usr/bin/ || die
			eend $?
			toremove=( "${toremove[@]}" "${f}" )
		done < <(find usr/$(get_libdir) -maxdepth 1 -name '*.dll')
		if [[ ${#toremove[@]} -gt 0 ]]
		then
			rm -f "${toremove[@]}" || die "removing dlls from usr/$(get_libdir) failed"
		fi
	fi
}

winnt_setup_dllhelper_cp() {
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

while [[ $# -gt 0 ]]
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
	[[ ${#mysrcs[@]} -lt 2 ]] && exit 0
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
	winnt_setup_dllhelper
fi
