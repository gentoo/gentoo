# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libasyncns-python/libasyncns-python-0.7.1-r1.ebuild,v 1.5 2015/04/08 08:05:20 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python bindings for libasyncns"
HOMEPAGE="https://launchpad.net/libasyncns-python/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/libasyncns-0.4"
RDEPEND="${DEPEND}"

python_compile() {
	if [[ ${EPYTHON} != python3* ]]; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

# Tests are network-dependent
