# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/socnetv/socnetv-0.90.ebuild,v 1.4 2013/03/02 19:31:48 hwoarang Exp $

EAPI="4"

inherit eutils qt4-r2 toolchain-funcs

MY_PN="SocNetV"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="http://socnetv.sourceforge.net/"
SRC_URI="mirror://sourceforge/socnetv/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-qt/qtgui:4
		dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}"

src_prepare() {
	qt4-r2_src_prepare
	sed -i "s/@make/@+make/" Makefile.in \
		|| die "Fix parallel build"
}

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${LDFLAGS} ${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin socnetv
	doicon src/images/socnetv.png
	make_desktop_entry  ${PN} SocNetV ${PN} 'Science'
	insinto /usr/share/${PN}/examples
	doins nets/*
	dodoc AUTHORS ChangeLog README TODO
	if use doc; then
		dohtml -r "${S}"/manual/*
	fi
	doman "${S}/man/${PN}.1.gz"
}
