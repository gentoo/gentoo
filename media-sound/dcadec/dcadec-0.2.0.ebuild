# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs multilib multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/foo86/dcadec.git"
	inherit git-r3
else
	SRC_URI="https://github.com/foo86/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

DESCRIPTION="DTS Coherent Acoustics decoder with support for HD extensions"
HOMEPAGE="https://github.com/foo86/dcadec"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
DOCS=( CHANGELOG.md README.md )

src_prepare() {
	sed -i \
		-e '/^CFLAGS/s:-O3::' \
		Makefile || die
}

multilib_src_compile() {
	# Build shared libs
	echo 'CONFIG_SHARED=1' >> .config

	local target=all
	multilib_is_native_abi || target=lib
	tc-export AR CC
	PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		emake -f "${S}/Makefile" ${target}
}

multilib_src_install() {
	local target=install
	multilib_is_native_abi || target=install-lib
	PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		emake -f "${S}/Makefile" DESTDIR="${D}" ${target}
}

multilib_src_install_all() {
	# Rename the executable since it conflicts with libdca.
	mv "${ED}"/usr/bin/dcadec{,-new} || die

	einstalldocs
}
