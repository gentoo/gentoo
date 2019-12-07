# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )
inherit distutils-r1

TOML_TEST_HASH="39bb76d631ba103a94b377aaf52c979456677fb1"

DESCRIPTION="Style-preserving TOML library for Python"
HOMEPAGE="https://github.com/sdispater/tomlkit https://pypi.python.org/pypi/tomlkit/"
SRC_URI="https://github.com/sdispater/tomlkit/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/BurntSushi/toml-test/archive/${TOML_TEST_HASH}.tar.gz -> ${P}-toml-test.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/python-enum34[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/functools32[${PYTHON_USEDEP}]' -2)
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/tomlkit-0.5.8-tests.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	printf -- "from setuptools import setup\nsetup(name='${PN}',version='${PV}',packages=['${PN}'])" \
		> setup.py

	if use test; then
		rmdir tests/toml-test || die
		mv "${WORKDIR}/toml-test-${TOML_TEST_HASH}" tests/toml-test || die
	fi

	distutils-r1_python_prepare_all
}
