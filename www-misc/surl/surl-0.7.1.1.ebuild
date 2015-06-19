# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/surl/surl-0.7.1.1.ebuild,v 1.2 2014/08/10 20:10:33 slyfox Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="URL shortening command line application that supports various sites"
HOMEPAGE="http://launchpad.net/surl"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV%.*}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	distutils-r1_src_install

	dodoc AUTHORS || die "doc install failed"
}
