# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-table/ibus-table-1.5.0.ebuild,v 1.2 2013/02/05 11:44:18 yngwin Exp $

EAPI=5
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="sqlite"
inherit eutils python

DESCRIPTION="The Table Engine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.16.1 )
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-pycompile.patch

	mv py-compile py-compile.orig || die
	ln -s "$(type -P true)" py-compile || die
	python_convert_shebangs 2 engine/tabcreatedb.py || die
	sed -i -e "s/python/python2/" \
		engine/ibus-table-createdb.in engine/ibus-engine-table.in || die
}

src_configure() {
	econf $(use_enable nls) PYTHON="${EPREFIX}"/usr/bin/python2
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}/engine
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}/engine
}
