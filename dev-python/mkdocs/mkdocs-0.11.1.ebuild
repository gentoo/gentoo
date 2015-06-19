# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mkdocs/mkdocs-0.11.1.ebuild,v 1.1 2015/03/01 21:11:20 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Project documentation with Markdown."
HOMEPAGE="http://www.mkdocs.org"
SRC_URI="https://github.com/tomchristie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

#<dev-python/markdown-2.5[${PYTHON_USEDEP}]
RDEPEND="
	>=dev-python/jinja-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/ghp-import-0.4.1[${PYTHON_USEDEP}]
"

python_compile_all() {
	if use doc; then
		"${PYTHON}" -m mkdocs.main build || die "failed to build documentation"
	fi
}

python_test() {
	nosetests mkdocs/test.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( site/. )

	distutils-r1_python_install_all
}
