# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Boilerplate library for logging method calls"
HOMEPAGE="
	https://github.com/reef-technologies/logfury
	https://pypi.org/project/logfury/
"
SRC_URI="
	https://github.com/reef-technologies/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# remove pin for old Pythons (sic!)
	sed -i -e '/setuptools_scm/d' setup.py || die
	distutils-r1_src_prepare
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}
