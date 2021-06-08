# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

DOCS_BUILDER="mkdocs"

inherit distutils-r1 docs

DESCRIPTION="A Python implementation of Lunr.js"
HOMEPAGE="https://github.com/yeraydiazdiaz/lunr.py"
SRC_URI="https://github.com/yeraydiazdiaz/lunr.py/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.py-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/nltk[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	epytest --ignore tests/acceptance_tests
}
