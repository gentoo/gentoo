# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for Augeas"
HOMEPAGE="
	https://augeas.net/
	https://github.com/hercules-team/python-augeas/
	https://pypi.org/project/python-augeas/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	app-admin/augeas
	>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/remove-tests.patch"
)

distutils_enable_tests unittest
