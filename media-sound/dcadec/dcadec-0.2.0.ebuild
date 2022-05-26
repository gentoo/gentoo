# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="DTS Coherent Acoustics decoder with support for HD extensions"
HOMEPAGE="https://github.com/foo86/dcadec"
SRC_URI="https://github.com/foo86/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips x86"

PATCHES=( "${FILESDIR}"/${P}-respect-CFLAGS.patch )

multilib_src_configure() {
	tc-export AR CC

	# Build shared libs
	echo 'CONFIG_SHARED=1' >> .config || die
}

multilib_src_compile() {
	local target=all
	multilib_is_native_abi || target=lib

	PREFIX="${EPREFIX}"/usr LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		emake -f "${S}"/Makefile ${target}
}

multilib_src_install() {
	local target=install
	multilib_is_native_abi || target=install-lib

	PREFIX="${EPREFIX}"/usr LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		emake -f "${S}"/Makefile DESTDIR="${D}" ${target}
}

multilib_src_install_all() {
	# Rename the executable since it conflicts with libdca.
	mv "${ED}"/usr/bin/dcadec{,-new} || die

	dodoc CHANGELOG.md README.md
}
