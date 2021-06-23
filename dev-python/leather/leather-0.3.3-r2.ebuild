# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Python charting for 80% of humans."
HOMEPAGE="https://github.com/wireservice/leather https://pypi.org/project/leather/"
SRC_URI="https://github.com/wireservice/leather/archive/refs/tags/${PV}.tar.gz -> ${P}-src.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +xml"
RESTRICT="!test? ( test )"

# Other packages have BDEPEND="test? ( dev-python/leather[xml] )"
TEST_AGAINST_RDEPEND="xml? ( dev-python/lxml[${PYTHON_USEDEP}] )"
RDEPEND="
	${TEST_AGAINST_RDEPEND}
	>=dev-python/cssselect-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

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
