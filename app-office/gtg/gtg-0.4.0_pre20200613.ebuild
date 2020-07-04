# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..8} )
PYTHON_REQ_USE="xml(+)"

inherit meson python-single-r1 xdg

DESCRIPTION="Personal organizer for the GNOME desktop environment"
HOMEPAGE="https://wiki.gnome.org/Apps/GTG/"
COMMIT="abe2a9110dd0fc6a46f2d095013972877ea67d78"
SRC_URI="https://github.com/getting-things-gnome/gtg/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/gtg-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring test"
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
	gnome-keyring? ( gnome-base/libgnome-keyring[introspection] )
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

PATCHES=( "${FILESDIR}"/fix-help-open.patch )

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/gtg
	python_optimize
}

src_test() {
	nosetests -v || die
}
