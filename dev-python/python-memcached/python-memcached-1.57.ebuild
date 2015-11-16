# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="Pure python memcached client"
HOMEPAGE="http://www.tummy.com/Community/software/python-memcached/ https://pypi.python.org/pypi/python-memcached"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		net-misc/memcached
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

# Tests try to connect to memcached via TCP/IP. Please do not re-enable
# until you get them all to pass properly while using the UNIX socket
# only and not even trying to connect to memcached over TCP/IP.
RESTRICT=test

python_test() {
	# Note: partial. Needs fixing. Stuff like that.

	cd "${TMPDIR}" || die

	local memcached_opts=( -d -P memcached.pid -s memcached.socket )
	[[ ${EUID} == 0 ]] && memcached_opts+=( -u portage )

	memcached "${memached_opts[@]}" || die

	"${PYTHON}" memcache.py --do-unix || die "Tests fail with ${EPYTHON}"

	kill "$(<memcached.pid)" || die
	rm memcached.pid || die
}
