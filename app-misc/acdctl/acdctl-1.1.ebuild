# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
