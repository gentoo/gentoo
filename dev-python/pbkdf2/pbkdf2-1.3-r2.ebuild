# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Implementation of PBKDF2, specified in RSA PKCS#5 v2.0"
HOMEPAGE="
	https://www.dlitz.net/software/python-pbkdf2/
	https://pypi.org/project/pbkdf2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

python_test() {
	"${EPYTHON}" test/test_pbkdf2.py -v || die "Tests failed with ${EPYTHON}"
}
