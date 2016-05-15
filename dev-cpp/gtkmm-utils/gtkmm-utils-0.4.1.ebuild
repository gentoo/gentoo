# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="Utility functions, classes and widgets written on top of gtkmm and
glibmm."
HOMEPAGE="https://code.google.com/p/gtkmm-utils/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-cpp/gtkmm:2.4"
DEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-glib.patch"
	epatch "${FILESDIR}/${P}-include-fix.patch"
}

src_configure() {
	append-cxxflags -std=c++11
	econf $(use_enable doc documentation)
}

src_install() {
	default
	prune_libtool_files
}
