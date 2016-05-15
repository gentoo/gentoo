# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
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
	doins "${FILESDIR}/orbited.cfg"
	newinitd "${FILESDIR}/orbited.init" orbited
}
