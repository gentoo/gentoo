# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

EGIT_COMMIT=3267e724a2d5ce0dbd388f62d549d870b76cb0f4
MY_P=python-iniparse-${EGIT_COMMIT}

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="
	https://github.com/candlepin/python-iniparse/
	https://pypi.org/project/iniparse/
"
SRC_URI="
	https://github.com/candlepin/python-iniparse/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
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
