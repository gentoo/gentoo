# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/socksipy/socksipy-1.00.ebuild,v 1.3 2015/04/08 08:05:23 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="SOCKS proxy implementation for python"
HOMEPAGE="http://socksipy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/SocksiPy%20${PV}/SocksiPy.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	python_foreach_impl python_domodule socks.py
}
