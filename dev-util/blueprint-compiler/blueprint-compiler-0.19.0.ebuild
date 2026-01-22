# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit edo meson python-single-r1 virtualx

DESCRIPTION="Compiler for Blueprint, a markup language for GTK user interfaces"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/blueprint-compiler/
	https://gitlab.gnome.org/GNOME/blueprint-compiler/"

if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/${PN}.git"
else
	inherit gnome.org

	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-3+"
SLOT="0"
IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	doc? (
		$(python_gen_cond_dep '
			dev-python/furo[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
	test? (
		gui-libs/gtk:4[introspection]
		gui-libs/libadwaita:1[introspection]
	)
"

DOCS=( CONTRIBUTING.md MAINTENANCE.md NEWS.md README.md )

src_prepare() {
	default

	rm ./tests/test_deprecations.py || die
	rm ./tests/test_samples.py || die  # Fails on CI, bug #947156
}

src_configure() {
	local -a emesonargs=(
		$(meson_use doc docs)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use doc ; then
		build_sphinx docs
	fi
}

src_test() {
	virtx edo "${EPYTHON}" -m unittest
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin"
	python_optimize
}
