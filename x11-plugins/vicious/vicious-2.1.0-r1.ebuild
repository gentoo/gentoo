# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/vicious/vicious-2.1.0-r1.ebuild,v 1.1 2013/02/05 23:25:49 wired Exp $

EAPI=5

DESCRIPTION="Modular widget library for x11-wm/awesome"
HOMEPAGE="http://awesome.naquadah.org/wiki/Vicious"
SRC_URI="http://git.sysphere.org/${PN}/snapshot/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="contrib"

DEPEND=""
RDEPEND="x11-wm/awesome"

src_install() {
	insinto /usr/share/awesome/lib/vicious
	doins -r widgets helpers.lua init.lua
	dodoc CHANGES README TODO

	if use contrib; then
		insinto /usr/share/awesome/lib/vicious/contrib
		doins contrib/*.lua
		newdoc contrib/README README.contrib
	fi
}
