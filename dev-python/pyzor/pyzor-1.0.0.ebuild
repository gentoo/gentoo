# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
PYHON_REQ_USE="gdbm"

inherit distutils-r1

MY_PV="1-0-0"
DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="https://github.com/SpamExperts/pyzor/"
SRC_URI="https://github.com/SpamExperts/${PN}/archive/release-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc gevent mysql pyzord redis test"

RDEPEND="mysql? ( $(python_gen_cond_dep '>=dev-python/mysql-python-1.2.5[${PYTHON_USEDEP}]' python2_7) )
	redis? ( ~dev-python/redis-py-2.9.1[${PYTHON_USEDEP}] )
	gevent? ( $(python_gen_cond_dep '~dev-python/gevent-1.0.1[${PYTHON_USEDEP}]' python2_7) )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# https://sourceforge.net/apps/trac/pyzor/attachment/ticket/196/
DISTUTILS_IN_SOURCE_BUILD=1

REQUIRED_USE="test? ( mysql redis )"
S="${WORKDIR}/${PN}-release-${MY_PV}"

python_test() {
	# The suite is py2 friendly only
	if ! python_is_python3; then
		PYTHONPATH=. "${PYTHON}" ./tests/unit/__init__.py
	fi
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}

src_install () {
	distutils-r1_src_install

	if use pyzord; then
		dodir /usr/sbin
		mv "${D}"usr/bin/pyzord* "${ED}usr/sbin"
	else
		rm "${D}"usr/bin/pyzord*
	fi
}

pkg_postinst() {
	if use pyzord; then
		ewarn "/usr/bin/pyzord has been moved to /usr/sbin"
	fi

	einfo "If you want to run the pyzor server you will need to emerge / re-emerge"
	einfo "with use flag mysql and or redis. Without either flag provides only the pyzor client"
}
