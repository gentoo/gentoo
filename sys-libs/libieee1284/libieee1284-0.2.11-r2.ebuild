# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

PYTHON_DEPEND="python? 2"
inherit python

DESCRIPTION="Library to query devices using IEEE1284"
HOMEPAGE="http://cyberelk.net/tim/libieee1284/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="doc python static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-sgml-utils
		>=app-text/docbook-sgml-dtd-4.1
		app-text/docbook-dsssl-stylesheets
		dev-perl/XML-RegExp
	)"

pkg_setup() {
	use python && python_set_active_version 2
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_with python) \
		--disable-dependency-tracking
}

src_install () {
	emake DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -delete
	dodoc AUTHORS NEWS README* TODO doc/interface*
}
