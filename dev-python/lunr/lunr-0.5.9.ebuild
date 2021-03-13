# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

DOCS_BUILDER="mkdocs"

inherit distutils-r1 docs

DESCRIPTION="A Python implementation of Lunr.js"
HOMEPAGE="https://github.com/yeraydiazdiaz/lunr.py"
SRC_URI="https://github.com/yeraydiazdiaz/lunr.py/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/nltk[${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
)"

S="${WORKDIR}/${PN}.py-${PV}"

distutils_enable_tests pytest

python_prepare_all() {
	# Tests in this subdir all fail
	# Command '['node', '/var/tmp/portage/dev-python/lunr-0.5.8/work/lunr.py-0.5.8/tests/acceptance_tests/javascript/mkdocs_load_serialized_index_and_search.js', '/var/tmp/portage/dev-python/lunr-0.5.8/temp/tmpldbff36d', 'plugins']' returned non-zero exit status 1.
	rm -r tests/acceptance_tests || die

	distutils-r1_python_prepare_all
}
