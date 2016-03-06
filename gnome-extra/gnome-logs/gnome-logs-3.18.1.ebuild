# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Log messages and event viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.43.90:2
	sys-apps/systemd
	>=x11-libs/gtk+-3.15.7:3
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.3
	dev-libs/appstream-glib
	dev-libs/libxslt
	>=dev-util/intltool-0.50
	dev-util/itstool
	virtual/pkgconfig
	test? ( dev-util/dogtail )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure $(use_enable test tests)
}

src_test() {
	Xemake check
}
