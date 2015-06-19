# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ifp-gnome/ifp-gnome-0.7.ebuild,v 1.6 2014/08/10 21:07:13 slyfox Exp $

EAPI=2

PYTHON_DEPEND=2
inherit eutils python

DESCRIPTION="Gnome front-end for file management on iRiver iFP MP3 players"
HOMEPAGE="http://ifp-gnome.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/libgnome-python-2
	>=dev-python/pygtk-2
	>=dev-python/pyifp-0.2.2"
DEPEND=""

S=${WORKDIR}/${PN}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs 2 ${PN}.py
	epatch "${FILESDIR}"/${P}-file-locations.patch
}

src_install() {
	insinto /usr/share/${PN}
	doins ${PN}.{glade,png} || die
	newbin ${PN}.py ${PN} || die
}
