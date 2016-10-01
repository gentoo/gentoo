# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{3,4,5} )
PYTHON_REQ_USE="threads"

inherit gnome2 python-r1

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/Orca"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

IUSE="+braille"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-accessibility/at-spi2-atk-2.12:2
	>=app-accessibility/at-spi2-core-2.12:2[introspection]
	>=dev-libs/atk-2.10
	>=dev-libs/glib-2.28:2
	dev-python/gst-python:1.0[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.10:3[${PYTHON_USEDEP}]
	media-libs/gstreamer:1.0[introspection]
	>=x11-libs/gtk+-3.6.2:3[introspection]
	braille? (
		>=app-accessibility/brltty-5.0-r3[python,${PYTHON_USEDEP}]
		dev-libs/liblouis[python,${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	>=app-accessibility/speech-dispatcher-0.8[python,${PYTHON_USEDEP}]
	dev-libs/atk[introspection]
	dev-python/pyatspi[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	x11-libs/libwnck:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	dev-util/itstool
	virtual/pkgconfig
"
#	app-text/yelp-tools

src_prepare() {
	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir gnome2_src_configure \
		$(use_with braille liblouis)
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_install() {
	installing() {
		gnome2_src_install
		# Massage shebang to make python_doscript happy
		sed -e 's:#!'"${PYTHON}:#!/usr/bin/python:" \
			-i src/orca/orca || die
		python_doscript src/orca/orca
	}
	python_foreach_impl run_in_build_dir installing
}
