# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit eutils vala

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="https://launchpad.net/libappindicator"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.26:2
	>=dev-libs/libdbusmenu-0.6.2[gtk3]
	>=dev-libs/libindicator-12.10.0:3
	>=x11-libs/gtk+-3.2:3
	introspection? ( >=dev-libs/gobject-introspection-1 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
"

src_prepare() {
	# Don't use -Werror
	sed -i -e 's/ -Werror//' {src,tests}/Makefile.{am,in} || die

	# Disable MONO for now because of https://bugs.gentoo.org/382491
	sed -i -e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' configure || die
	use introspection && vala_src_prepare
}

src_configure() {
	# https://bugs.gentoo.org/409133
	export APPINDICATOR_PYTHON_CFLAGS=' '
	export APPINDICATOR_PYTHON_LIBS=' '

	econf \
		--disable-silent-rules \
		--disable-static \
		--with-html-dir=/usr/share/doc/${PF}/html \
		--with-gtk=3
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog

	prune_libtool_files
}
