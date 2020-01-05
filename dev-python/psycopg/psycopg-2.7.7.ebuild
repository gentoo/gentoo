# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 flag-o-matic

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="http://initd.org/psycopg/ https://pypi.org/project/psycopg2/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="debug doc examples"

RDEPEND=">=dev-db/postgresql-8.1:*"
DEPEND="${RDEPEND}
	doc? (
		>=dev-python/pygments-2.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.6[${PYTHON_USEDEP}]
	)"

RESTRICT="test"

# Avoid using mxdatetime: https://bugs.gentoo.org/452028
PATCHES=( "${FILESDIR}"/psycopg-2.7.3-avoid-mxdatetime.patch )

S="${WORKDIR}/${MY_P}"

python_compile() {
	local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}

	! python_is_python3 && append-flags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_prepare_all() {
	if use debug; then
		sed -i 's/^\(define=\)/\1PSYCOPG_DEBUG,/' setup.cfg || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc/src -j1 html text
}

python_install_all() {
	if use doc; then
		dodoc -r doc/src/_build/html
		dodoc doc/src/_build/text/*
	fi

	if use examples ; then
	   dodoc -r examples
	   docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
