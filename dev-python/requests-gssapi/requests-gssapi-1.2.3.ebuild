# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A Kerberos authentication handler for python-requests"
HOMEPAGE="
	https://github.com/requests/requests-gssapi/
	https://pypi.org/project/requests-gssapi/
	"

SRC_URI="https://github.com/pythongssapi/requests-gssapi/releases/download/v${PV}/requests-gssapi-${PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/requests-1.1.0[${PYTHON_USEDEP}]
	dev-python/gssapi[${PYTHON_USEDEP}]
	"

RESTRICT="test" # Don't know how
#BDEPEND="
#	test? (
#		dev-python/pytest-mock[${PYTHON_USEDEP}]
#	)
#	"

#distutils_enable_tests pytest
