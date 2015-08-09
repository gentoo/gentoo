# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.6"

inherit eutils python

DESCRIPTION="Configuration GUI for x11-misc/wbar"
HOMEPAGE="http://koti.kapsi.fi/ighea/wbarconf/"
SRC_URI="http://koti.kapsi.fi/ighea/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-misc/wbar-1.3.3
	dev-python/pygobject:2
	dev-python/pygtk:2
	sys-devel/gettext"
DEPEND=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-install.patch
}

src_install() {
	./install.sh "${D}/usr" || die "./install.sh failed."
}
