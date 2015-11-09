# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# pypy doesn't get started in test run. Still required by www-servers/gunicorn
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Allow customization of the process title"
HOMEPAGE="https://code.google.com/p/py-setproctitle/ https://pypi.python.org/pypi/setproctitle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos \
	~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

# Required for re-write of test suite
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	# Make a nice html file
	rst2html.py README.rst > README.html
	# The README.rst will be duplicated in src_install
	rm README.rst || die
}

python_test() {
	# The suite via the Makefile appears to not cater to pypy
	if [[ "${EPYTHON}" != pypy ]]; then
		emake check
	fi
}
