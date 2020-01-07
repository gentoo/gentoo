# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=(python2_7 python3_6)
inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: Support EditorConfig files "
HOMEPAGE="https://editorconfig.org/"
SRC_URI="https://github.com/${PN%-vim}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-python/editorconfig-core-py[${PYTHON_USEDEP}]
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-python3.patch"
	"${FILESDIR}/${P}-max-line-length-off.patch"
	"${FILESDIR}/${P}-fixes.patch"
)

VIM_PLUGIN_HELPFILES="${PN%-vim}.txt"

src_prepare() {
	default

	rm LICENSE mkzip.sh .editorconfig .gitignore .travis.yml || die
	rm -r tests plugin/${PN%-vim}-core-py || die
}
