# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="a gesture-recognition application for X11"
HOMEPAGE="https://sourceforge.net/apps/trac/easystroke/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-cpp/gtkmm:3.0
	dev-libs/boost
	dev-libs/dbus-glib
	dev-libs/glib:2
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cellrendertextish.patch
	epatch "${FILESDIR}"/${P}-desktop.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-reinstate-signal-handlers.patch
	epatch "${FILESDIR}"/${P}-buttons-scroll-send.patch
	epatch "${FILESDIR}"/${P}-cxx11.patch

	tc-export CC CXX PKG_CONFIG

	if ! [[ -z ${LINGUAS} ]]; then
		strip-linguas -i po/

		local es_lingua lang
		for es_lingua in $( printf "%s\n" po/*.po ); do
			lang=${es_lingua/po\/}
			has ${lang/.po/} ${LINGUAS} || rm ${es_lingua}
		done
	fi
}

src_compile() {
	append-cxxflags -std=c++11
	emake \
		AOFLAGS='' \
		LDFLAGS="${LDFLAGS}" \
		PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
