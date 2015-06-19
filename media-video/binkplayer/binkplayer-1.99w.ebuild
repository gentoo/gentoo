# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/binkplayer/binkplayer-1.99w.ebuild,v 1.11 2015/06/01 20:40:06 mr_bones_ Exp $

EAPI=5
DESCRIPTION="Bink Video! Player"
HOMEPAGE="http://www.radgametools.com/default.htm"
# No version on the archives and upstream has said they are not
# interested in providing versioned archives.
SRC_URI="mirror://gentoo/${P}.zip"

# distributable per http://www.radgametools.com/binkfaq.htm
LICENSE="freedist"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	>=media-libs/libsdl-1.2.15-r5[abi_x86_32(-)]
	>=media-libs/openal-1.15.1-r1[abi_x86_32(-)]"

S=${WORKDIR}

QA_PREBUILT="opt/bin/BinkPlayer"

src_install() {
	into /opt
	dobin BinkPlayer
}
