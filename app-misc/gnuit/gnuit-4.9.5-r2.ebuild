# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gnuit/gnuit-4.9.5-r2.ebuild,v 1.2 2015/06/26 12:14:16 ago Exp $

EAPI=5

inherit eutils

DESCRIPTION="GNU Interactive Tools - increase speed and efficiency of most daily tasks"
HOMEPAGE="http://www.gnu.org/software/gnuit/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-format-security.patch
}

src_configure() {
	# The transition option controls whether a "git" wrapper is installed, it is
	# disabled explicitly so we don't need to block on dev-vcs/git.
	econf --disable-transition
}

src_install() {
	default
	#emake DESTDIR="${D}" htmldir="/usr/share/doc/${PF}/html" install
	mv "${D}/usr/bin/gitview" "${D}/usr/bin/gnuitview" || die
}

pkg_postinst() {
	elog "The 'git' tool this package previously installed is now called 'gitfm'"
	elog "The 'gitview' tool this package previously installed is now called 'gnuitview'"
	elog "If you want the 'gitaction' tool to use your preferred desktop"
	elog "application settings install the 'x11-misc/xdg-utils' package."
}
