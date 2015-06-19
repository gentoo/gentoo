# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmsound/wmsound-0.9.5.ebuild,v 1.11 2012/06/14 19:15:02 ssuominen Exp $

EAPI=4
inherit eutils multilib toolchain-funcs

DESCRIPTION="WindowMaker sound server"
HOMEPAGE="http://largo.windowmaker.org/"
SRC_URI="http://largo.windowmaker.org/files/${P}.tar.gz"

RDEPEND="media-sound/wmsound-data
	x11-libs/libproplist
	x11-wm/windowmaker"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-config.patch \
		"${FILESDIR}"/${PN}-ComplexProgramTargetNoMan.patch

	# Fix building with -Wl,--as-needed
	sed -i \
		-e 's:-lPropList $(WMSOUNDLIB):$(WMSOUNDLIB) -lPropList:' \
		src/Imakefile || die
	sed -i \
		-e 's:-lPropList $(XLIB) $(WMSOUNDLIB):$(WMSOUNDLIB) -lPropList	$(XLIB):' \
		utils/Imakefile || die
}

src_compile() {
	xmkmf -a || die
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake PREFIX="${D}/usr" USRLIBDIR="${D}/usr/$(get_libdir)" install
	dodoc AUTHORS BUGS ChangeLog
}
