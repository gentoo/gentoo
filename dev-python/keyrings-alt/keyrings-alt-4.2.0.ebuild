# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P="${P/-/.}"
DESCRIPTION="Alternate keyring implementations"
HOMEPAGE="
	https://github.com/jaraco/keyrings.alt/
	https://pypi.org/project/keyrings.alt/
"
SRC_URI="
	https://github.com/jaraco/keyrings.alt/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	!dev-python/keyrings_alt
"
BDEPEND="
	>=dev-python/setuptools_scm-3.4.1[${PYTHON_USEDEP}]
	test? (
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	# oldschool namespaces
	rm keyrings/__init__.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -k 'not Cryptodome'
}
