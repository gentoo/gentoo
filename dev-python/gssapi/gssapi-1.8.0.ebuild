# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Low and high level wrappers around the GSSAPI C libraries"
HOMEPAGE="https://github.com/pythongssapi/python-gssapi https://pypi.org/project/gssapi/"
SRC_URI="
	https://github.com/pythongssapi/python-gssapi/releases/download/v${PV}/python-${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}"/python-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	virtual/krb5
"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/krb5
	test? (
		dev-python/k5test[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	cd "${T}" || die
	epytest --pyargs gssapi
}
