# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: chainload-provider.eclass
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @AUTHOR:
# Aisha Tammy <gentoo@aisha.cc>
# @SUPPORTED_EAPIS: 7
# @BLURB: library chainloading utilities, for dummy libraries
# @DESCRIPTION:
# Helper functions for creating dummy libraries which link
# to actual providers to get around runtime SONAME dependencies
# and without the need to create extra copies of libraries.
# Specifically made for BLAS and LAPACK providers but is
# usable for any and all libraries.

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

inherit flag-o-matic toolchain-funcs

# @ECLASS-VARIABLE: PROVIDER_NAME
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# Name of the provider to be used all library registrations
[[ -z ${PROVIDER_NAME+unset} ]] && die "PROVIDER_NAME needs to be defined and non empty"

# @FUNCTION: provider-link-lib
# @USAGE: <libname> <prepended_ldflags>
# @DESCRIPTION:
# Create a dummy C library for chain loading.
# Creates a ${libname} in the ${T} folder.
# EXAMPLE:
# @CODE
# provider-link-lib libcblas.so.3 -Llib/generic -lblis-mt
# @CODE
provider-link-lib() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ $# -lt 2 ]]; then
		die -q "need <libname> <prepended_ldflags"
	fi
	local libname=$1 lname
	shift 1
	# remove trailing .so.* and starting lib
	lname=${libname%%.*}
	lname=${lname##lib}
	cat <<-EOF > "${T}"/gentoo_${lname}.c || die
	const char *__gentoo_${lname}_provider(void){
		return "${PROVIDER_NAME}";
	}
	EOF

	tc-export CC
	local needed="$(no-as-needed)"
	emake -f - <<EOF
all:
	\$(CC) -shared -fPIC \$(CFLAGS) -o "${T}"/${libname} "${T}"/gentoo_${lname}.c -Wl,--soname,${libname} -Wl,--push-state ${needed} ${@} -Wl,--pop-state \$(LDFLAGS)
EOF
}

# @FUNCTION: provider-install-lib
# @USAGE: <libname> [<dir>]
# @DESCRIPTION:
# Install the created ${libname} to ${dir}
# ${dir} defaults to /usr/$(get_libdir)/${lname}/${PROVIDER_NAME}
provider-install-lib() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ $# -ne 1 ]] && [[ $# -ne 2 ]]; then
		die -q "need <libname> [<dir>]"
	fi
	local libname=$1 lname dir
	# remove trailing .so.* and starting lib
	lname=${libname%%.*}
	lname=${lname##lib}
	dir="/usr/$(get_libdir)/${lname}/${PROVIDER_NAME}"
	[[ $# -eq 2 ]] && dir="${2}"
	insinto ${dir}
	insopts -m755
	doins "${T}"/${libname}
	dosym ${libname} ${dir}/lib${lname}.so
}
