# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7 python3_4 python3_5)
inherit python-r1 vim-plugin

DESCRIPTION="vim plugin: Support EditorConfig files "
HOMEPAGE="http://editorconfig.org/"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/${PN%-vim}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="dev-python/editorconfig-core-py[${PYTHON_USEDEP}]
	|| (
	app-editors/vim[python,${PYTHON_USEDEP}]
	app-editors/gvim[python,${PYTHON_USEDEP}]
)"

VIM_PLUGIN_HELPFILES="${PN%-vim}.txt"

src_prepare() {
	default

	rm LICENSE mkzip.sh .editorconfig .gitignore .travis.yml || die
	rm -r tests plugin/${PN%-vim}-core-py || die
}
