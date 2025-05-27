# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=eyeD3-${PV}
DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="
	https://eyed3.nicfit.net/
	https://github.com/nicfit/eyeD3/
	https://pypi.org/project/eyeD3/
"
SRC_URI="
	https://github.com/nicfit/eyeD3/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	test? (
		https://eyed3.nicfit.net/releases/eyeD3-test-data.tgz
			-> eyeD3-test-data-r1.tgz
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3+"
SLOT="0.7"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/deprecation-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/filetype-1.2.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# note: most of the deps are optional runtime deps / plugin deps
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pylast[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# unpackaged deps
	tests/test_factory.py
)

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/eyeD3-test-data tests/data || die
	fi

	distutils-r1_src_prepare
}
