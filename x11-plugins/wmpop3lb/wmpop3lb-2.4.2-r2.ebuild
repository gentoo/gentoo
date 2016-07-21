# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

IUSE=""

MY_P=${PN}${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="dockapp for checking up to 7 pop3 accounts"
HOMEPAGE="http://wmpop3lb.jourdain.org"
SRC_URI="http://lbj.free.fr/wmpop3/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=sys-apps/sed-4"

src_prepare() {
	#Honour Gentoo CFLAGS
	sed -i -e "s:-g2 -D_DEBUG:${CFLAGS}:" "wmpop3/Makefile"

	#Fix bug #161530
	epatch "${FILESDIR}"/${P}-fix-RECV-and-try-STAT-if-LAST-wont-work.patch

	#De-hardcode compiler
	sed -i -e "s:cc:\$(CC):g" "wmpop3/Makefile"

	#Honour Gentoo LDFLAGS - bug #335986
	sed -i -e "s:\$(FLAGS) -o wmpop3lb:\$(LDFLAGS) -o wmpop3lb:" "wmpop3/Makefile"

	epatch "${FILESDIR}"/${P}-list.patch
}

src_compile() {
	emake -C wmpop3 || die "parallel make failed"
}

src_install() {
	dobin wmpop3/wmpop3lb
	dodoc CHANGE_LOG README
}
