# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit gnome2 python-r1

DESCRIPTION="Input assistive technology intended for switch and pointer users"
HOMEPAGE="https://wiki.gnome.org/Projects/Caribou"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	app-accessibility/at-spi2-core
	>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
	>=x11-libs/gtk+-3:3[introspection]
	x11-libs/gtk+:2
	>=dev-libs/gobject-introspection-0.10.7:=
	dev-libs/libgee:0.8
	dev-libs/libxml2
	>=media-libs/clutter-1.5.11:1.0[introspection]
	x11-libs/libX11
	x11-libs/libxklavier
	x11-libs/libXtst
"
# gsettings-desktop-schemas is needed for the 'toolkit-accessibility' key
# pyatspi-2.1.90 needed to run caribou if pygobject:3 is installed
# librsvg needed to load svg images in css styles
RDEPEND="${COMMON_DEPEND}
	dev-libs/glib[dbus]
	>=dev-python/pyatspi-2.1.90[${PYTHON_USEDEP}]
	>=gnome-base/gsettings-desktop-schemas-3
	gnome-base/librsvg:2
	sys-apps/dbus
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.35.5
	virtual/pkgconfig
"

src_prepare() {
	# delete custom PYTHONPATH, useless on Gentoo and potential bug source
	# + caribou is python2 only so fix the shell scripts
	sed -e '/export PYTHONPATH=.*python/ d' \
		-e "s:@PYTHON@:${EPREFIX}/usr/bin/python2:" \
		-i bin/{antler-keyboard,caribou-preferences}.in ||
		die "sed failed"

	gnome2_src_prepare

	prepare_caribou() {
		mkdir -p "${BUILD_DIR}" || die
	}
	python_foreach_impl prepare_caribou
}

src_configure() {
	ECONF_SOURCE="${S}" python_foreach_impl run_in_build_dir \
		gnome2_src_configure \
			--disable-docs \
			--disable-static \
			--enable-gtk3-module \
			--enable-gtk2-module \
			VALAC=$(type -P true)
	# vala is not needed for tarball builds, but configure checks for it...
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir gnome2_src_install
	dodoc AUTHORS NEWS README # ChangeLog simply points to git log
}
