# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/hippo-canvas/hippo-canvas-0.3.0-r2.ebuild,v 1.4 2015/04/08 17:28:02 mgorny Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 multilib python-single-r1

DESCRIPTION="A canvas library based on GTK+ 2, Cairo, and Pango"
HOMEPAGE="https://wiki.gnome.org/Projects/HippoCanvas"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.6:2
	dev-libs/libcroco
	>=x11-libs/gtk+-2.6:2
	x11-libs/pango
	gnome-base/librsvg:2
	python? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cd "${S}/python"
	epatch "${FILESDIR}/${PN}-python-override.patch"
	cd "${S}"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable python)
}
