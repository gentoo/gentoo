# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..9} )
PYTHON_REQ_USE="xml(+)"

inherit meson python-single-r1 xdg

DESCRIPTION="Personal organizer for the GNOME desktop environment"
HOMEPAGE="https://wiki.gnome.org/Apps/GTG/"
SRC_URI="https://github.com/getting-things-gnome/gtg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

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
		>=dev-python/liblarch-3.1.0[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
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
		|| ( app-text/pdfjam >=app-text/texlive-core-2021 )
		app-text/pdftk
		dev-texlive/texlive-latex
	)
"

PATCHES=(
	# Fixes tests, and mouse cursor with some themes
	"${FILESDIR}"/${PV}-mouse-cursor-fixes{1,2,3}.patch
	"${FILESDIR}"/0.5-Revert-meson-plugin-translation-apply-thing.patch
)

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/gtg
	python_optimize
}

src_test() {
	sed -e "s|@VCS_TAG@|${PV}|" GTG/core/info.py.in > GTG/core/info.py || die
	nosetests -v || die
}
