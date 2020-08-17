# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Allow customization of the process title"
HOMEPAGE="https://github.com/dvarrazzo/py-setproctitle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

python_configure_all() {
	2to3 -w --no-diffs tests || die
}

python_test() {
	if [[ ${EPYTHON} != pypy* ]]; then
		# prepare executable for embedded interpreter test
		# (skipped with pypy)
		rm -f tests/pyrun3 || die
		emake \
			CC="$(tc-getCC)" \
			PYINC="$(python_get_CFLAGS)" \
			PYLIB="$(python_get_LIBS)" \
			tests/pyrun3
	fi

	"${EPYTHON}" tests/setproctitle_test.py -v || die "Tests failed with ${EPYTHON}"
}
