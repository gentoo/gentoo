# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1

DESCRIPTION="Greenbone Vulnerability Management Python Library"
HOMEPAGE="https://www.greenbone.net/en/ https://github.com/greenbone/python-gvm/"
SRC_URI="https://github.com/greenbone/python-gvm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}"

distutils_enable_tests unittest
