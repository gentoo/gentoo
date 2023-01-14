# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Greenbone Vulnerability Management Python Library"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/python-gvm/"
SRC_URI="https://github.com/greenbone/python-gvm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# drop connection tests
	rm -r tests/connections || die
}
