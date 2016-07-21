# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="C Implementation of NTRUEncrypt"
HOMEPAGE="https://github.com/tbuktu/libntru"
SRC_URI="https://github.com/tbuktu/libntru/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples static-libs"

DEPEND="dev-lang/perl"

src_prepare() {
	multilib_copy_sources

	_copy_test_dir() {
		cp -pr "${BUILD_DIR}" "${BUILD_DIR}-test" || die
	}
	multilib_foreach_abi _copy_test_dir
}

multilib_src_compile() {
	CFLAGS="${CFLAGS}" \
		emake \
			CC="$(tc-getCC)" \
			$(usex static-libs "libntru.a libntru.so" "") \
			MACHINE="$(if [[ ${ABI} == x86 ]] ; then echo i386 ; else echo x86_64 ; fi)"
}

src_test() {
	_test() {
		CFLAGS="${CFLAGS}" \
			emake CC="$(tc-getCC)" test -j1 -C "${BUILD_DIR}-test" \
				MACHINE="$(if [[ ${ABI} == x86 ]] ; then echo i386 ; else echo x86_64 ; fi)"

	}

	multilib_foreach_abi _test
}

multilib_src_install() {
	emake \
		DESTDIR="${ED}" \
		INST_LIBDIR="/usr/$(get_libdir)" \
		INST_DOCDIR="/usr/share/doc/${PF}" \
		MACHINE="$(if [[ ${ABI} == x86 ]] ; then echo i386 ; else echo x86_64 ; fi)" \
		install $(usex static-libs install-static-lib "")
}

multilib_src_install_all() {
	einstalldocs
	if use examples ; then
		docinto examples
		dodoc src/hybrid.c
	fi
}
