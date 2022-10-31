# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Library for testing Python applications in Kerberos 5 environments"
HOMEPAGE="
	https://github.com/pythongssapi/k5test/
	https://pypi.org/project/k5test/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

PATCHES=(
	"${FILESDIR}"/${P}-which.patch
)
