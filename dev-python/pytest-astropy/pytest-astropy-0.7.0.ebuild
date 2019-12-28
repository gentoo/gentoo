# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DOCS=( README.rst LICENSE.rst CHANGES.rst )

DESCRIPTION="A meta-package that pulls in the dependencies that are used by astropy"
HOMEPAGE="https://github.com/astropy/pytest-astropy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pytest-3.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-doctestplus-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-remotedata-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-openfiles-0.3.1[${PYTHON_USEDEP}]
	dev-python/pytest-astropy-header[${PYTHON_USEDEP}]
	>=dev-python/pytest-arraydiff-0.1[${PYTHON_USEDEP}]
	dev-python/hypothesis[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
