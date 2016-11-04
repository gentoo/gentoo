# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7)
inherit vim-plugin distutils-r1

DESCRIPTION="vim plugin: Support EditorConfig files "
HOMEPAGE="http://editorconfig.org/"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/${PN%-vim}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )"

VIM_PLUGIN_HELPFILES="${PN%-vim}.txt"

PYTHON_S="${S}/plugin/${PN%-vim}-core-py"

src_prepare() {
	default
	pushd "${PYTHON_S}" > /dev/null
	python_setup
	distutils-r1_src_prepare
	popd > /dev/null

	rm LICENSE mkzip.sh .editorconfig .gitignore .travis.yml || die
	rm -r tests || die
}

python_compile() {
	pushd "${PYTHON_S}" > /dev/null
	distutils-r1_python_compile
	popd > /dev/null
}

src_install() {
	pushd "${PYTHON_S}" > /dev/null
	distutils-r1_src_install
	popd > /dev/null

	rm -r "${PYTHON_S}"
	vim-plugin_src_install
}
