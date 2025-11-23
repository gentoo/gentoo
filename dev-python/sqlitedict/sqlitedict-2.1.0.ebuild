# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi

DESCRIPTION="Persistent dict in Python, backed by SQLite and pickle"
HOMEPAGE="
	https://github.com/piskvorky/sqlitedict/
	https://pypi.org/project/sqlitedict/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

DOCS=( README.rst )

distutils_enable_tests pytest

python_test() {
	mkdir -p tests/db || die
	distutils-r1_python_test
}
