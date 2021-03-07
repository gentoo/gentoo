# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
# TODO: revert to rdepend once this is merged:
# https://github.com/collective/collective.checkdocs/pull/11
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Distutils command to view/validate packages's rst text long_descriptions."
HOMEPAGE="https://github.com/collective/collective.checkdocs"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.zip"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"  # until https://github.com/collective/collective.checkdocs/issues/8 is fixed
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
