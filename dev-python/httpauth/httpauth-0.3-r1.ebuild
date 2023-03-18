# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A WSGI middleware that secures routes using HTTP Digest Authentication"
HOMEPAGE="https://github.com/jonashaag/httpauth/"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-remove-nose-dependency.patch"
)

distutils_enable_tests pytest

python_test() {
	epytest tests.py
}
