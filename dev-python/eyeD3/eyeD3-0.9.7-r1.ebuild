# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="
	https://eyed3.nicfit.net/
	https://github.com/nicfit/eyeD3/
	https://pypi.org/project/eyed3/
"
SRC_URI="
	https://github.com/nicfit/eyeD3/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://eyed3.nicfit.net/releases/eyeD3-test-data.tgz
			-> eyeD3-test-data-r1.tgz
	)
"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/filetype[${PYTHON_USEDEP}]
	|| (
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
# note: most of the deps are optional runtime deps / plugin deps
BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pylast[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# unpackaged deps
	tests/test_factory.py
)

EPYTEST_DESELECT=(
	# broken by formatting / line wrapping
	tests/test_jsonyaml_plugin.py::testYamlPlugin
)

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/eyeD3-test-data tests/data || die
	fi

	# don't install everything to site-packages
	sed -i -e '/^include = /,/\]/d' pyproject.toml || die
	# optional without putting it in extra group == non-optional, sigh
	sed -i -e '/coverage/d' pyproject.toml || die

	distutils-r1_src_prepare
}
