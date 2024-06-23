# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1

DESCRIPTION="spinoff from folium, host the non-map-specific features"
HOMEPAGE="https://github.com/python-visualization/branca"
SRC_URI="https://github.com/python-visualization/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${PN}-0.6.0-test.patch )

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools-scm
	test? (
		dev-python/selenium[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

distutils_enable_sphinx docs/source \
	dev-python/nbsphinx

python_test() {
	epytest -m 'not headless'
}
