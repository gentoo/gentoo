# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=emojicodes-${PV}
DESCRIPTION="Extension to use emoji codes in your Sphinx documentation"
HOMEPAGE="
	https://pypi.org/project/sphinxemoji/
	https://github.com/sphinx-contrib/emojicodes/
"
SRC_URI="
	https://github.com/sphinx-contrib/emojicodes/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/sphinx-5.0[${PYTHON_USEDEP}]
"

python_test() {
	local HTML_DOCS=()
	build_sphinx docs/source
	rm -r docs/source/_build || die
}
