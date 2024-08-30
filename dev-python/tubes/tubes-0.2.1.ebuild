# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Flow control and backpressure for event-driven applications"
HOMEPAGE="
	https://github.com/twisted/tubes/
	https://pypi.org/project/Tubes/
"
SRC_URI="
	https://github.com/twisted/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# fix tests on py3.12
	# https://github.com/twisted/tubes/pull/95
	sed -i -e 's:assertEquals:assertEqual:' tubes/test/*.py || die

	distutils-r1_src_prepare
}
