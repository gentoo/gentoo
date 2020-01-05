# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

TOML_TEST_VER="39bb76d631ba103a94b377aaf52c979456677fb1"

DESCRIPTION="Python library for handling TOML files"
HOMEPAGE="https://github.com/uiri/toml"
SRC_URI="https://github.com/uiri/${PN}/archive/${PV}.tar.gz -> ${P}-1.tar.gz
	test? ( https://github.com/BurntSushi/toml-test/archive/${TOML_TEST_VER}.tar.gz -> toml-test-${TOML_TEST_VER}.tar.gz )"
IUSE="test"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~sparc ~x86"

# peculiar testing depending on https://github.com/BurntSushi/toml-test. Not
# particularly worth the trouble.
#RESTRICT="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' 'python3*') )"

PATCHES=(
	"${FILESDIR}/toml-0.10.0-depricationwarning.patch"
)

DOCS=( README.rst )

distutils_enable_tests pytest

python_prepare_all() {
	if use test; then
		mv "${WORKDIR}/toml-test-${TOML_TEST_VER#v}" "${S}/toml-test" || die
	fi

	distutils-r1_python_prepare_all
}
