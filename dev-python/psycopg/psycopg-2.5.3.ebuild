# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/psycopg/psycopg-2.5.3.ebuild,v 1.15 2015/04/08 08:04:54 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 flag-o-matic

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="http://initd.org/psycopg/ http://pypi.python.org/pypi/psycopg2"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="debug doc examples"

RDEPEND=">=dev-db/postgresql-8.1"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

python_compile() {
	local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}

	[[ ${EPYTHON} != python3* ]] && append-flags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-2.4.2-setup.py.patch"
	)

	if use debug; then
		sed -i 's/^\(define=\)/\1PSYCOPG_DEBUG,/' setup.cfg || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc -j1 html text
}

python_install_all() {
	distutils-r1_python_install_all

	dodoc doc/{HACKING,SUCCESS}

	if use doc; then
		dodoc doc/psycopg2.txt
		dohtml -r doc/html/.
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/.
	fi
}
