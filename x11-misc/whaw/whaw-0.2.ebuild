# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Window manager independent Window Layout tool"
HOMEPAGE="http://repetae.net/computer/whaw/"
SRC_URI="http://repetae.net/computer/${PN}/drop/whaw-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/popt
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXmu
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-implicit-declaration-warning.patch"
	epatch_user
}
