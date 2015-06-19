# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/orbited/orbited-0.7.10-r2.ebuild,v 1.1 2015/03/07 11:22:21 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Real-time communication for the browser."
HOMEPAGE="http://orbited.org"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/demjson[${PYTHON_USEDEP}]
	>=dev-python/morbid-0.8.4[${PYTHON_USEDEP}]
	dev-python/stomper[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install
	insinto /etc
	doins "${FILESDIR}/orbited.cfg" || die
	newinitd "${FILESDIR}/orbited.init" orbited || die
}
