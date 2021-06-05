# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Convert text with ANSI color codes to HTML"
HOMEPAGE="https://pypi.org/project/ansi2html/ https://github.com/pycontribs/ansi2html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="doc"

RDEPEND=">=dev-python/six-1.7.3[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	doc? (
		app-text/asciidoc
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install pytest

python_install_all() {
	use doc && doman man/${PN}.1
	distutils-r1_python_install_all
}

src_compile() {
	# Upstream https://github.com/pycontribs/ansi2html/issues/124
	use doc && emake man/ansi2html.1
	distutils-r1_src_compile
}
