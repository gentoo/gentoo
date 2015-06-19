# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/obexfs/obexfs-0.12.ebuild,v 1.2 2015/01/04 11:06:06 pacho Exp $

EAPI=5

DESCRIPTION="FUSE filesystem interface for ObexFTP"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFs"
SRC_URI="mirror://sourceforge/openobex/files/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=app-mobilephone/obexftp-0.22
	sys-fs/fuse
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix building, bug #523062 (from ArchLinux)
	export OBEXFTP_CFLAGS="-I/usr/include/obexftp -I/usr/include/multicobex -I/usr/include/bfb"
	export OBEXFTP_LIBS="-lobexftp -lmulticobex -lbfb -lopenobex -lbluetooth"
}
