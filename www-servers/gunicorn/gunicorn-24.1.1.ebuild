# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="
	https://gunicorn.org/
	https://github.com/benoitc/gunicorn/
	https://pypi.org/project/gunicorn/
"
SRC_URI="
	https://github.com/benoitc/gunicorn/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# removed deps
		tests/workers/test_geventlet.py
		tests/workers/test_ggevent.py
	)

	epytest -o addopts=
}
