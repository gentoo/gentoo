# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Kerberos API bindings for Python"
HOMEPAGE="
	https://github.com/jborean93/pykrb5/
	https://pypi.org/project/krb5/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	virtual/krb5
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/k5test[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/jborean93/pykrb5/pull/27
	"${FILESDIR}/${P}-cython-3.patch"
)
