# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/jmtpfs/jmtpfs-0.5.ebuild,v 1.1 2015/03/07 11:26:34 jer Exp $

EAPI=5

inherit autotools

DESCRIPTION="A FUSE and libmtp based filesystem for accessing MTP devices"
HOMEPAGE="https://github.com/JasonFerrara/jmtpfs"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=media-libs/libmtp-1.1.6
	sys-fs/fuse
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=(AUTHORS NEWS README)

src_prepare() {
	eautoreconf
}
