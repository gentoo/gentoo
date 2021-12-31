# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A library for computing contrast ratios, as required by WCAG 2.0"
HOMEPAGE="
	https://github.com/gsnedders/wcag-contrast-ratio/
	https://pypi.org/project/wcag-contrast-ratio/"
SRC_URI="
	https://github.com/gsnedders/wcag-contrast-ratio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~sparc"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	epytest test.py
}
