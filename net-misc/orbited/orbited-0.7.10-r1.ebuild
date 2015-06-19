# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/orbited/orbited-0.7.10-r1.ebuild,v 1.6 2014/08/10 20:46:18 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Real-time communication for the browser"
HOMEPAGE="http://orbited.org"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/demjson
	>=dev-python/morbid-0.8.4
	dev-python/stomper
	dev-python/twisted-core
	dev-python/twisted-web"
DEPEND="${RDEPEND}
	dev-python/setuptools"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
	insinto /etc
	doins "${FILESDIR}/orbited.cfg" || die
	newinitd "${FILESDIR}/orbited.init" orbited || die
}
