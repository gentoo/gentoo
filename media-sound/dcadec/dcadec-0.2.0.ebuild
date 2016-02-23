# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs multilib

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

src_configure() {
	tc-export AR CC
	sed -i \
		-e "/^PREFIX /s:=.*:= ${EPREFIX}/usr:" \
		-e "/^LIBDIR /s:/lib:/$(get_libdir):" \
		-e '/^CFLAGS/s:-O3::' \
		Makefile || die
}

src_install() {
	default
	# Rename the executable since it conflicts with libdca.
	mv "${ED}"/usr/bin/dcadec{,-new} || die
}
