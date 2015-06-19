# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cfv/cfv-1.18.3-r1.ebuild,v 1.2 2014/12/26 18:11:21 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Utility to test and create .sfv, .csv, .crc and md5sum files"
HOMEPAGE="http://cfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/cfv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="bittorrent"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	dev-python/python-fchksum[${PYTHON_USEDEP}]
	bittorrent? (
		|| (
			net-p2p/bittorrent[${PYTHON_USEDEP}]
			net-p2p/bittornado[${PYTHON_USEDEP}]
		)
	)"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_compile() {
	:
}

src_install() {
	python_fix_shebang cfv
	dobin cfv
	doman cfv.1
	dodoc README Changelog
}
