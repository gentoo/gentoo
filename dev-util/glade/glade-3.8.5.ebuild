# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME_ORG_MODULE="glade3"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-single-r1

DESCRIPTION="A user interface designer for GTK+ and GNOME"
HOMEPAGE="http://glade.gnome.org/"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="3/11" # subslot = suffix of libgladeui-1.so
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="gnome python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.8:2
	>=x11-libs/gtk+-2.24:2
	>=dev-libs/libxml2-2.4:2
	gnome?	(
		>=gnome-base/libgnomeui-2
		>=gnome-base/libbonoboui-2 )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygtk-2.10:2 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.9
	app-text/docbook-xml-dtd:4.1.2
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--enable-libtool-lock \
		$(use_enable gnome) \
		$(use_enable python)
}
