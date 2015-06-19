# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/mpdcon/mpdcon-1.5.1.ebuild,v 1.1 2014/01/30 00:11:56 voyageur Exp $

EAPI=5
inherit gnustep-2

MY_P=${P/mpdc/MPDC}
DESCRIPTION="GNUstep client for the Music Player Daemon"
HOMEPAGE="http://gap.nongnu.org/mpdcon/"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-libs/libbsd
	>=gnustep-libs/sqlclient-1.6.0[sqlite]
	>=media-libs/libmpdclient-2.7"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	egnustep_env
	egnustep_make need-libbsd=yes
}
