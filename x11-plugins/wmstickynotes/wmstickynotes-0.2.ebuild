# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmstickynotes/wmstickynotes-0.2.ebuild,v 1.2 2012/06/21 11:56:20 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="A dockapp for keeping small notes around on the desktop"
HOMEPAGE="http://wmstickynotes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gold.patch
}
