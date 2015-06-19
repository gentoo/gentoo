# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/conf-update/conf-update-1.0.2.ebuild,v 1.8 2014/05/16 19:57:52 nimiux Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="${PN} is a ncurses-based config management utility"
HOMEPAGE="http://dev.gentoo.org/~nimiux/app-portage/${PN}"
SRC_URI="http://dev.gentoo.org/~nimiux/app-portage/${PN}/distfiles/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="colordiff"

RDEPEND=">=dev-libs/glib-2.6
		sys-libs/ncurses
		dev-libs/openssl
		colordiff? ( app-misc/colordiff )"
DEPEND="virtual/pkgconfig
		${RDEPEND}"

src_prepare() {
	sed -i -e "s/\$Rev:.*\\$/${PVR}/" "${S}"/"${PN}".h || \
		die 'version-sed failed'

	if use colordiff ; then
		sed -i -e "s/diff_tool=diff/diff_tool=colordiff/" ${PN}.conf || \
			die 'colordiff-sed failed'
	fi
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" install
}
