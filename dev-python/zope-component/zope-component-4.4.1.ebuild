# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=(python3_{8..10})

inherit distutils-r1
MY_PN=zope.component
MY_P=${MY_PN}-${PV}

DESCRIPTION="Zope Component Architecture"
HOMEPAGE="https://github.com/zopefoundation/zope.component
	https://docs.zope.org/zope.component/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="dev-python/namespace-zope[${PYTHON_USEDEP}]
	dev-python/zope-event[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.1.0[${PYTHON_USEDEP}]"

# Uses multiple new dependencies, which isn't worth it
RESTRICT="test"

distutils_enable_tests nose

python_install_all() {
	distutils-r1_python_install_all

	# remove .pth files since dev-python/namespace-zope handles the ns
	find "${D}" -name '*.pth' -delete || die
}
