# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Gnome install & update software"
HOMEPAGE="http://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=app-admin/packagekit-base-1.0.9
	dev-db/sqlite:3
	>=dev-libs/appstream-glib-0.5.1:0
	>=dev-libs/glib-2.45.8:2
	>=gnome-base/gnome-desktop-3.17.92:3=
	>=gnome-base/gsettings-desktop-schemas-3.11.5
	net-libs/libsoup:2.4
	sys-auth/polkit
	>=x11-libs/gtk+-3.16:3
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? ( dev-util/dogtail )
"
# test? ( dev-util/valgrind )

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# valgrind fails with SIGTRAP
	sed -e 's/TESTS = .*/TESTS =/' \
		-i "${S}"/src/Makefile.{am,in} || die

	gnome2_src_prepare
}

src_configure() {
	# FIXME: investigate limba and firmware update support
	gnome2_src_configure \
		--enable-man \
		--disable-firmware \
		--disable-limba \
		$(use_enable test dogtail)
}

src_test() {
	Xemake check TESTS_ENVIRONMENT="dbus-run-session"
}
