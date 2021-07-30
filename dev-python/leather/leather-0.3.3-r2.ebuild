# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python charting for 80% of humans."
HOMEPAGE="https://github.com/wireservice/leather https://pypi.org/project/leather/"
SRC_URI="https://github.com/wireservice/leather/archive/refs/tags/${PV}.tar.gz -> ${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xml"

# Other packages have BDEPEND="test? ( dev-python/leather[xml] )"
TEST_AGAINST_RDEPEND="xml? ( dev-python/lxml[${PYTHON_USEDEP}] )"
RDEPEND="
	${TEST_AGAINST_RDEPEND}
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

python_prepare_all() {
	local requirements_files sed_args

	sed_args=(
		-e '/coverage/d'
		-e '/lxml/d' # lxml is required only when leather is used as a test dependency
		-e '/nose/d'
		-e '/tox/d'
		-e '/Sphinx/d'
		-e '/sphinx_rtd_theme/d'
		-e '/unittest2/d'
	)

	requirements_files+=(requirements*.txt)
	sed "${sed_args[@]}" -i "${requirements_files[@]}" || die
	distutils-r1_python_prepare_all
}
