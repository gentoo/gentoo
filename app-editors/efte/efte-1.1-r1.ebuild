# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/efte/efte-1.1-r1.ebuild,v 1.3 2013/07/27 22:23:23 ago Exp $

EAPI=5

inherit eutils cmake-utils fdo-mime

DESCRIPTION="A fast text editor supporting folding, syntax highlighting, etc."
HOMEPAGE="http://efte.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gpm X"

RDEPEND="sys-libs/ncurses
	gpm? ( sys-libs/gpm )
	X? (
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXdmcp
		x11-libs/libXau
		media-fonts/font-misc-misc
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch \
		"${FILESDIR}"/${P}-desktopfile.patch
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build gpm)
		$(cmake-utils_use_build X)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -f "${D}"/usr/share/doc/${PN}/{COPYING,Artistic}
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
