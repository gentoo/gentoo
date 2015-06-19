# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-skk/ibus-skk-1.4.1.ebuild,v 1.1 2012/07/08 21:29:28 naota Exp $

EAPI=4
PYTHON_DEPEND="2:2.5"

inherit python

DESCRIPTION="Japanese input method Anthy IMEngine for IBus Framework"
HOMEPAGE="http://github.com/ueno/ibus-skk"
SRC_URI="mirror://github/ueno/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.3
	>=app-i18n/libskk-0.0.11
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"
RDEPEND="${RDEPEND}
	app-i18n/skk-jisyo"

DOCS="ChangeLog NEWS README THANKS"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	>py-compile
}

src_configure() {
	econf $(use_enable nls)
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
