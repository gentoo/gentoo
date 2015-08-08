# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYHON_REQ_USE="gdbm"

inherit distutils-r1

DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="http://pyzor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="mysql pyzord redis test"

RDEPEND="mysql? ( $(python_gen_cond_dep '>=dev-python/mysql-python-1.2.5[${PYTHON_USEDEP}]' python2_7) )
		redis? ( ~dev-python/redis-py-2.9.1[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# https://sourceforge.net/apps/trac/pyzor/attachment/ticket/196/
DISTUTILS_IN_SOURCE_BUILD=1

REQUIRED_USE="test? ( mysql redis )"

python_test() {
	# https://sourceforge.net/apps/trac/pyzor/ticket/196
	# In this ticket it clearly states the suite is written for py2
	# While it's feasible to make it into a py3 ready state, nah
	if ! python_is_python3; then
		PYTHONPATH=. "${PYTHON}" ./tests/unit/__init__.py
	fi
}

src_install () {
	distutils-r1_src_install

	if use pyzord; then
		dodir /usr/sbin
		mv "${ED}"usr/bin/pyzord* "${ED}usr/sbin"
	else
		rm "${ED}"usr/bin/pyzord*
	fi
}

pkg_postinst() {
	if use pyzord; then
		ewarn "/usr/bin/pyzord has been moved to /usr/sbin"
	fi

	einfo "If you want to run the pyzor server you will need to emerge / re-emerge"
	einfo "with use flag mysql and or redis. Without either flag provides only the pyzor client"
}
