# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sublib/sublib-0.9.ebuild,v 1.7 2014/08/10 21:12:26 slyfox Exp $

inherit mono

DESCRIPTION="Subtitling library that allows for subtitle editing, conversion and synchronization"
HOMEPAGE="http://sublib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}
	app-arch/unzip"

src_install() {
	einstall || die "einstall failed"
}
