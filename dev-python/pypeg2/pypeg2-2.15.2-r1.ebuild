# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN=pyPEG2
MY_P=${MY_PN}-${PV}

DESCRIPTION="An intrinsic PEG Parser-Interpreter for Python"
HOMEPAGE="https://fdik.org/pyPEG/
	https://pypi.org/project/pyPEG2/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-2.15.1-test.patch )

distutils_enable_tests unittest
