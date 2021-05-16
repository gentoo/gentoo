# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..8} )
PYTHON_REQ_USE="xml(+)"

inherit meson python-single-r1 xdg

DESCRIPTION="Personal organizer for the GNOME desktop environment"
HOMEPAGE="https://wiki.gnome.org/Apps/GTG/"
SRC_URI="https://github.com/getting-things-gnome/gtg/releases/download/v0.4/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		>=dev-python/liblarch-3.0[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
	')
	x11-libs/pango[introspection]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	test? ( $(python_gen_cond_dep '
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/cheetah3[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
		')
		app-text/pdfjam
		app-text/pdftk
		dev-texlive/texlive-latex
	)
"

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/gtg
	python_optimize
}

src_test() {
	nosetests -v || die
}
