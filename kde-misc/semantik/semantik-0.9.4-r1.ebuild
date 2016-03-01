# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_REQUIRED="never"
NO_WAF_LIBDIR="true"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+),xml"
inherit eutils python-single-r1 kde4-base waf-utils

DESCRIPTION="Mindmapping-like tool for document generation"
HOMEPAGE="http://freehackers.org/~tnagy/semantik.html https://code.google.com/p/semantik/"
SRC_URI="http://ftp.waf.io/pub/release/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README TODO )

pkg_setup() {
	python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.0-wscript_ldconfig.patch"
}
