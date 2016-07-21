# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="FUSE filesystem interface for ObexFTP"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFs"
SRC_URI="http://triq.net/obexftp/${P/_/-}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=app-mobilephone/obexftp-0.22
	sys-fs/fuse"
RDEPEND=${DEPEND}

S="${WORKDIR}/${P%_*}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
