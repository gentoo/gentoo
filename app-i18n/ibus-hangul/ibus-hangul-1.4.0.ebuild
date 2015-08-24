# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.5"

inherit python

DESCRIPTION="The Hangul engine for IBus input platform"
HOMEPAGE="https://code.google.com/p/ibus/"
SRC_URI="https://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.4
	=dev-python/pygobject-2*
	=dev-python/pygtk-2*
	>=app-i18n/libhangul-0.1
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		>=sys-devel/gettext-0.17
		)"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	>py-compile
	python_convert_shebangs 2 setup/ibus-setup-hangul.in
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
