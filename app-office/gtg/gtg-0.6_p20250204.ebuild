# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_10 python3_{12..13} )
PYTHON_REQ_USE="xml(+)"

inherit meson optfeature python-single-r1 xdg

COMMIT=cd348da367019c92c16c73e40f6bdcbdfd3fc413

DESCRIPTION="Personal organizer for the GNOME desktop environment"
HOMEPAGE="https://getting-things-gnome.github.io/"
# SRC_URI="https://github.com/getting-things-gnome/gtg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/getting-things-gnome/gtg/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/caldav[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	app-crypt/libsecret[introspection]
	>dev-libs/glib-2.78.6[introspection]
	dev-libs/libportal
	gui-libs/gtk:4[introspection]
	gui-libs/gtksourceview:5[introspection]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	test? (
		$(python_gen_cond_dep '
			dev-python/cheetah3[${PYTHON_USEDEP}]
			dev-python/icalendar[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
		|| ( app-text/pdfjam >=app-text/texlive-core-2021 )
		app-text/pdftk
		dev-texlive/texlive-latex
	)
"
DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default
	sed -e "s|@VCS_TAG@|$(ver_cut 1-2)|" GTG/core/info.py.in > GTG/core/info.py || die
}

src_test() {
	EPYTEST_IGNORE=(
		tests/core/test_taskview.py # segfaults
	)
	epytest
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/gtg
	python_optimize
}

pkg_postinst() {
	optfeature "Custom process title (ex. in ps command)" dev-python/setproctitle
}
