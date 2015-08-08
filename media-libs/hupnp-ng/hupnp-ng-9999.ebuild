# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/0xd34df00d/hupnp-ng.git"

inherit multilib base qt4-r2 git-r3

DESCRIPTION="A software library for building UPnP devices, fork of herqq"
HOMEPAGE="https://github.com/0xd34df00d/hupnp-ng"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""

# no release of QtSolutions using bundled libQtSolutions_SOAP
RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtxmlpatterns:4
	!media-libs/herqq
"
DEPEND="${RDEPEND}"

src_prepare() {
	# fix the .pro file for multilib issues
	sed \
		-e "s:PREFIX/lib:PREFIX/$(get_libdir):" \
		-i "${S}/hupnp/src.pro" \
		-i "${S}/hupnp_av/hupnp_av.pro" \
		-i "${S}/hupnp/lib/qtsoap-2.7-opensource/buildlib/buildlib.pro" || die

	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 \
		PREFIX="${EPREFIX}/usr" \
		"CONFIG += DISABLE_AVTESTAPP" \
		"CONFIG += DISABLE_TESTAPP" \
		herqq.pro
}
