# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dosemu/dosemu-1.4.1_pre20091009.ebuild,v 1.6 2015/03/01 01:50:56 slyfox Exp $

inherit eutils flag-o-matic

P_FD="dosemu-freedos-1.0-bin"
DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="mirror://sourceforge/dosemu/${P_FD}.tgz
	mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="X svga gpm debug alsa sndfile"

RDEPEND="X? ( x11-libs/libXxf86vm
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-apps/xset
		x11-apps/xlsfonts
		x11-apps/bdftopcf
		x11-apps/mkfontdir )
	svga? ( media-libs/svgalib )
	gpm? ( sys-libs/gpm )
	alsa? ( media-libs/alsa-lib )
	sndfile? ( media-libs/libsndfile )
	>=sys-libs/slang-1.4"

DEPEND="${RDEPEND}
	X? ( x11-proto/xf86dgaproto )
	>=sys-devel/autoconf-2.57"
S="${WORKDIR}/${PN}"

src_compile() {
	epatch "${FILESDIR}"/${P}-flex.patch #437074

	# Has problems with -O3 on some systems
	replace-flags -O[3-9] -O2

	unset KERNEL

	econf `use_with X x` \
		`use_enable svga svgalib` \
		`use_enable debug` \
		`use_with gpm` \
		`use_with alsa` \
		`use_with sndfile` \
		--with-fdtarball="${DISTDIR}"/${P_FD}.tgz \
		--sysconfdir=/etc/dosemu/ \
		--with-docdir=/usr/share/doc/${PF} || die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	# Don't remove COPYING, see bug #137286
	dodoc BUGS ChangeLog COPYING NEWS README THANKS || die #nowarn
}
