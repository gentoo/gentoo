# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: multilib-minimal.eclass
# @MAINTAINER:
# Multilib team <multilib@gentoo.org>
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: wrapper for multilib builds providing convenient multilib_src_* functions
# @DESCRIPTION:
#
# src_configure, src_compile, src_test and src_install are exported.
#
# Use multilib_src_* instead of src_* which runs this phase for
# all enabled ABIs.
#
# multilib-minimal should _always_ go last in inherit order!
#
# If you want to use in-source builds, then you must run
# multilib_copy_sources at the end of src_prepare!
# Also make sure to set correct variables such as
# ECONF_SOURCE=${S}
#
# If you need generic install rules, use multilib_src_install_all function.


# EAPI=4 is required for meaningful MULTILIB_USEDEP.
case ${EAPI:-0} in
	4|5|6|7) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac


[[ ${EAPI} == [45] ]] && inherit eutils
inherit multilib-build

EXPORT_FUNCTIONS src_configure src_compile src_test src_install


multilib-minimal_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	multilib-minimal_abi_src_configure() {
		debug-print-function ${FUNCNAME} "$@"

		mkdir -p "${BUILD_DIR}" || die
		pushd "${BUILD_DIR}" >/dev/null || die
		if declare -f multilib_src_configure >/dev/null ; then
			multilib_src_configure
		else
			default_src_configure
		fi
		popd >/dev/null || die
	}

	multilib_foreach_abi multilib-minimal_abi_src_configure
}

multilib-minimal_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	multilib-minimal_abi_src_compile() {
		debug-print-function ${FUNCNAME} "$@"

		pushd "${BUILD_DIR}" >/dev/null || die
		if declare -f multilib_src_compile >/dev/null ; then
			multilib_src_compile
		else
			default_src_compile
		fi
		popd >/dev/null || die
	}

	multilib_foreach_abi multilib-minimal_abi_src_compile
}

multilib-minimal_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	multilib-minimal_abi_src_test() {
		debug-print-function ${FUNCNAME} "$@"

		pushd "${BUILD_DIR}" >/dev/null || die
		if declare -f multilib_src_test >/dev/null ; then
			multilib_src_test
		else
			default_src_test
		fi
		popd >/dev/null || die
	}

	multilib_foreach_abi multilib-minimal_abi_src_test
}

multilib-minimal_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	multilib-minimal_abi_src_install() {
		debug-print-function ${FUNCNAME} "$@"

		pushd "${BUILD_DIR}" >/dev/null || die
		if declare -f multilib_src_install >/dev/null ; then
			multilib_src_install
		else
			# default_src_install will not work here as it will
			# break handling of DOCS wrt #468092
			# so we split up the emake and doc-install part
			# this is synced with __eapi4_src_install
			if [[ -f Makefile || -f GNUmakefile || -f makefile ]] ; then
				emake DESTDIR="${D}" install
			fi
		fi

		multilib_prepare_wrappers
		multilib_check_headers
		popd >/dev/null || die
	}
	multilib_foreach_abi multilib-minimal_abi_src_install
	multilib_install_wrappers

	if declare -f multilib_src_install_all >/dev/null ; then
		multilib_src_install_all
	else
		einstalldocs
	fi
}
