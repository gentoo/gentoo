# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/idesk-extras/idesk-extras-1.37-r1.ebuild,v 1.3 2014/08/10 17:38:06 ago Exp $

EAPI=5

inherit eutils

DESCRIPTION="Graphical configuration for iDesk plus icons"
HOMEPAGE="http://www.jmurray.id.au/idesk-extras.html" # dead?
SRC_URI="http://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-shells/bash
	x11-misc/idesk
	x11-misc/xdialog"

src_prepare() {
	epatch "${FILESDIR}"/${P}-stdout.patch
}

src_install() {
	dobin idesktool
	dodoc CHANGES
	dohtml ${PN}.html

	insinto /usr/share/idesk
	doins -r icons
}
