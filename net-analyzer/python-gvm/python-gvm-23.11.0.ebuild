# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Greenbone Vulnerability Management Python Library"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/python-gvm/"
SRC_URI="https://github.com/greenbone/python-gvm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	>=dev-python/defusedxml-0.6[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.7.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# drop connection tests
	rm -r tests/connections || die
}
