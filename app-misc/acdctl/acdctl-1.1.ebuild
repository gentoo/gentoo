# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/acdctl/acdctl-1.1.ebuild,v 1.6 2012/05/22 16:27:12 ssuominen Exp $

EAPI=4

DESCRIPTION="Apple Cinema Display Control"
HOMEPAGE="http://www.technocage.com/~caskey/acdctl/"
SRC_URI="http://www.technocage.com/~caskey/acdctl/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_install() {
	dobin acdctl
	dodoc CHANGELOG README
}
