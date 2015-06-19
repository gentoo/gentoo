# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/flack/flack-2.0.6.ebuild,v 1.1 2011/10/23 17:52:21 sbriesen Exp $

EAPI=4

inherit eutils

DESCRIPTION="flack - edit FLAC tags from command line"
HOMEPAGE="http://sourceforge.net/projects/flack/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-3.2
	>=media-libs/flac-1.2.1"

src_install() {
	dobin flack
	insinto etc
	doins flackrc
	dodoc ChangeLog README
}
