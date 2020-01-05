# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
MY_PV="${PV/_p/.post}"
inherit distutils-r1

DESCRIPTION="PyTest Salt Plugin"
HOMEPAGE="https://github.com/saltstack/pytest-salt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.2.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"
