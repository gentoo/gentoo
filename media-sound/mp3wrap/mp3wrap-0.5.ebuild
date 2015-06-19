# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3wrap/mp3wrap-0.5.ebuild,v 1.15 2014/08/10 21:09:03 slyfox Exp $

DESCRIPTION="Command-line utility that wraps quickly two or more mp3 files in one single large playable mp3"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"
HOMEPAGE="http://mp3wrap.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	dobin mp3wrap || die "dobin failed"
	doman mp3wrap.1
	dodoc AUTHORS ChangeLog README
	dohtml doc/*.html
}
