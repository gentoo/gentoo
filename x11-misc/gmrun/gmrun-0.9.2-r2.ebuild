# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A GTK-2 based launcher box with bash style auto completion!"
HOMEPAGE="https://sourceforge.net/projects/gmrun/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/popt
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.10 )
	sys-apps/sed
	virtual/pkgconfig
"

src_prepare() {
	eapply \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc6-pie.patch \
		"${FILESDIR}"/${P}-sysconfdir.patch \
		"${FILESDIR}"/${P}-glibc210.patch \
		"${FILESDIR}"/${P}-stlport.patch

	eapply_user
	eautoreconf
}
