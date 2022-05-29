# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Small library to dynamically create Python functions"
HOMEPAGE="https://pypi.org/project/makefun/ https://github.com/smarie/python-makefun"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-1.13.1-no_pytest-runner.patch
)

distutils_enable_tests pytest
