# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subsync/subsync-0.0.1.ebuild,v 1.1 2010/08/08 00:45:27 sbriesen Exp $

EAPI="2"

inherit eutils

DESCRIPTION="subsync is an program that synchronizes srt subtitle files"
HOMEPAGE="http://sourceforge.net/projects/subsync/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog
}
