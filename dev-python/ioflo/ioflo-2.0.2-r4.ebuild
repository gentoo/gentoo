# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Automated Reasoning Engine and Flow Based Programming Framework"
HOMEPAGE="
	https://github.com/ioflo/ioflo/
	https://pypi.org/project/ioflo/
"
SRC_URI="
	https://github.com/ioflo/ioflo/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

PATCHES=(
	"${FILESDIR}/ioflo-1.7.8-network-test.patch"
	"${FILESDIR}/ioflo-2.0.2-python39.patch"
	"${FILESDIR}/ioflo-2.0.2-tests.patch"
	"${FILESDIR}/ioflo-2.0.2-py310.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's:"setuptools_git[^"]*",::' -i setup.py || die
	distutils-r1_python_prepare_all
}
