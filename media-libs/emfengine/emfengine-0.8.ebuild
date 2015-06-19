# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emfengine/emfengine-0.8.ebuild,v 1.5 2015/02/27 07:47:16 jlec Exp $

EAPI=5

inherit eutils qmake-utils

MY_PN="EmfEngine"

DESCRIPTION="Native vector graphics file format on Windows"
HOMEPAGE="http://soft.proindependent.com/emf/index.html"
SRC_URI="http://dev.gentoo.org/~jelc/distfiles/${MY_PN}-${PV}-opensource.zip"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/libemf
	media-libs/libpng:0
	"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/${MY_PN}

PATCHES=(
	"${FILESDIR}/0.7-config.patch"
	"${FILESDIR}/0.7-header.patch"
	"${FILESDIR}"/${PV}-example.patch
	)

src_prepare() {
	edos2unix EmfEngine.pro
	epatch ${PATCHES[@]}
	sed \
		-e "s:/usr/local/lib/libEMF.a:-lEMF:g" \
		-e "s:/usr/local/include:${EPREFIX}/usr/include/:g" \
		-i src/src.pro example/example.pro || die
}

src_configure() {
	eqmake4
}

src_install() {
	dolib.so libEmfEngine.so*
	doheader src/*.h*
}
