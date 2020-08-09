# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="https://eyed3.nicfit.net/"
SRC_URI="https://github.com/nicfit/eyeD3/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://eyed3.nicfit.net/releases/eyeD3-test-data.tgz )"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/filetype[${PYTHON_USEDEP}]"
# note: most of the deps are optional runtime deps / plugin deps
BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pylast[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	# requires unpackaged factory-boy, doesn't seem to relevant
	# to anything but eyeD3 usage with factory-boy
	rm test/test_factory.py || die
	# requires unpackaged grako
	rm test/test_display_plugin.py || die

	if use test; then
		mv "${WORKDIR}"/eyeD3-test-data test/data || die
	fi

	distutils-r1_src_prepare
}
