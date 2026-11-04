# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="
	https://github.com/candlepin/python-iniparse/
	https://pypi.org/project/iniparse/
"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_install_all() {
	rm -rf "${ED}/usr/share/doc" || die
	distutils-r1_python_install_all
}
