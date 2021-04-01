# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE="threads(+)"

inherit gnome2 python-single-r1

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/Orca"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

IUSE="+braille"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-accessibility/at-spi2-atk-2.34:2
	>=app-accessibility/at-spi2-core-2.36:2[introspection]
	>=dev-libs/atk-2.36
	>=dev-libs/glib-2.28:2
	media-libs/gstreamer:1.0[introspection]
	>=x11-libs/gtk+-3.6.2:3[introspection]
	$(python_gen_cond_dep '
		dev-python/gst-python:1.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pygobject-3.18:3[${PYTHON_MULTI_USEDEP}]
	')
	braille? (
		$(python_gen_cond_dep '
			>=app-accessibility/brltty-5.0-r3[python,${PYTHON_MULTI_USEDEP}]
			dev-libs/liblouis[python,${PYTHON_MULTI_USEDEP}]
		')
	)
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/atk[introspection]
	$(python_gen_cond_dep '
		>=app-accessibility/speech-dispatcher-0.8[python,${PYTHON_MULTI_USEDEP}]
		>=dev-python/pyatspi-2.36[${PYTHON_MULTI_USEDEP}]
		dev-python/setproctitle[${PYTHON_MULTI_USEDEP}]
	')
	x11-libs/libwnck:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${COMMON_DEPEND}
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
#	app-text/yelp-tools

src_configure() {
	gnome2_src_configure \
		$(use_with braille liblouis)
}

src_install() {
	gnome2_src_install
	python_optimize
}
