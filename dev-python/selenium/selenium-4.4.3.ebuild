# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# GitHub releases don't include generated files, and on PyPi we do have them
# but only in a wheel format.

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="https://www.seleniumhq.org"
SRC_URI="
	https://files.pythonhosted.org/packages/py3/${P::1}/${PN}/${P}-py3-none-any.whl
"
S=${WORKDIR}

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
"

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/${P}-py3-none-any.whl"
}
