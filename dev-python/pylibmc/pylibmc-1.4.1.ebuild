# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylibmc/pylibmc-1.4.1.ebuild,v 1.1 2014/12/10 04:06:29 patrick Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="http://sendapatch.se/projects/pylibmc/ http://pypi.python.org/pypi/pylibmc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-libs/libmemcached-0.32"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -e "/with-info=1/d" -i setup.cfg
	distutils-r1_python_prepare_all
}

src_test() {
	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
}

python_test() {
	local PIDDIR="${T}/${EPYTHON}-pylibmc"
	mkdir "${PIDDIR}" || die
	chmod 0777 "${PIDDIR}" || die
	memcached -d -p 11219 -u nobody -l localhost -P "${PIDDIR}/m.pid" || die
	MEMCACHED_PORT=11219 nosetests || die
	kill `cat "${PIDDIR}/m.pid"`
}
