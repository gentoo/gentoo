# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/granite/granite-0.1.0.ebuild,v 1.4 2013/07/27 21:29:21 jlec Exp $

EAPI=4

VALA_MIN_API_VERSION="0.14"

inherit cmake-utils multilib vala

DESCRIPTION="A development library for elementary development"
HOMEPAGE="http://launchpad.net/granite"
SRC_URI="http://launchpad.net/${PN}/${PV%.*.*}.x/${PV%.*}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/libgee:0
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS )

src_prepare() {
	vala_src_prepare
	sed -i -e "/NAMES/s:valac:${VALAC}:" cmake/FindVala.cmake || die
	sed -i -e "/DESTINATION/s:lib:$(get_libdir):" lib/CMakeLists.txt || die
}

src_install() {
	cmake-utils_src_install
	dohtml -r doc/*
}
