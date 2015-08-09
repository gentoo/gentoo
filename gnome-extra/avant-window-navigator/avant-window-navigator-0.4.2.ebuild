# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no
GNOME2_LA_PUNT=yes
PYTHON_COMPAT=( python2_7 )
VALA_USE_DEPEND=vapigen

inherit autotools eutils gnome2 python-single-r1 vala

DESCRIPTION="A dock-like bar which sits at the bottom of the screen"
HOMEPAGE="https://github.com/p12tic/awn"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gconf"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/dbus-glib-0.80
	>=dev-libs/glib-2.16
	>=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}]
	>=gnome-base/libgtop-2
	>=x11-libs/gtk+-2.12:2
	>=x11-libs/libdesktop-agnostic-0.3.9[gconf?]
	>=x11-libs/libwnck-2.22:1
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/librsvg-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-vcs/bzr
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	gconf? ( >=gnome-base/gconf-2 )
	"
DEPEND="
	${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto
	dev-util/gtk-doc
"

S="${WORKDIR}/awn-${PV}"

pkg_setup() {
	python-single-r1_pkg_setup

	G2CONF="--disable-static
		--disable-pymod-checks
		$(use_enable doc gtk-doc)
		$(use_enable gconf schemas-install)
		--disable-shave
		--with-html-dir=/usr/share/doc/${PF}/html"

	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.0-underlinking.patch
	epatch "${FILESDIR}"/${PN}-0.4.2-Timeout.patch
	eautoreconf

	python_fix_shebang awn-settings/awnSettings{.py.in,Helper.py}

	gnome2_src_prepare
	vala_src_prepare
}
