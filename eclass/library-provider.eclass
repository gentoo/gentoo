# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: library-provider.eclass
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @AUTHOR:
# Aisha Tammy <gentoo@aisha.cc>
# @SUPPORTED_EAPIS: 7
# @BLURB: pkg_postinst/rm functions for eselect library
# @DESCRIPTION:
# default implementations of pkg_postinst/rm
# for a library provider

case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

RDEPEND="app-eselect/eselect-library"

EXPORT_FUNCTIONS pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: PROVIDER_NAME
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# Name of the provider to be used all library registrations
[[ -z ${PROVIDER_NAME+unset} ]] && die "PROVIDER_NAME needs to be defined and non empty"

# @ECLASS-VARIABLE: PROVIDER_LIBS
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# libraries provided by this package with eselect-library
# Should be a bash array
[[ -z ${PROVIDER_LIBS+unset} ]] && die "PROVIDER_LIBS needs to be defined and non empty"
[[ $(declare -p PROVIDER_LIBS 2>/dev/null) == "declare -a"* ]] || \
	die "PROVIDER_LIBS needs to be a bash array"

# @ECLASS-VARIABLE: PROVIDER_DIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Directoriess in which libraries are registered
# PROVIDER_LIBS[i] should be present in PROVIDER_DIRS[i]
# PROVIDER_DIRS[i] defaults to ${EROOT}/usr/$(get_libdir)/${LIBNAME}/${PROVIDER_NAME}
# Should either be unset or a bash array
[[ -z ${PROVIDER_DIRS+unset} ]] || 
	[[ $(declare -p PROVIDER_DIRS 2>/dev/null) == "declare -a"* ]] || \
	die "PROVIDER_DIRS needs to be a bash array"

library-provider_pkg_postinst() {
	local libdir=$(get_libdir)
	local plib pdir
	local icnt=0
	for plib in ${PROVIDER_LIBS[@]}; do
		if [[ $icnt -lt ${#PROVIDER_DIRS[@]} ]]; then
			pdir="${EROOT%/}${PROVIDER_DIRS[$icnt]}"
		else
			pdir="${EROOT%/}/usr/${libdir}/${plib}/${PROVIDER_NAME}"
		fi
		icnt=$((icnt + 1))
		elog "Adding ${PROVIDER_NAME} [${pdir}] as a provider for ${plib}"
		eselect library add ${plib} ${libdir} ${pdir} ${PROVIDER_NAME}
		elog "Added ${PROVIDER_NAME} [${pdir}] as a provider for ${plib}"
		local current_library=$(eselect library show ${plib} ${libdir} | cut -d' ' -f2)
		elog "Current provider: ${plib} ($libdir) -> [${current_library}]"
		if [[ ${current_library} == "${PROVIDER_NAME}" ]]; then
			eselect library set ${plib} ${libdir} ${PROVIDER_NAME}
		else
			elog "To use ${PROVIDER_NAME} as the provider for ${plib}, you have to issue (as root):"
			elog "\t eselect library set ${plib} ${libdir} ${PROVIDER_NAME}"
		fi
	done
}

library-provider_pkg_postrm() {
	local plib
	for plib in ${PROVIDER_LIBS[@]}; do
		eselect library validate ${plib}
	done
}
