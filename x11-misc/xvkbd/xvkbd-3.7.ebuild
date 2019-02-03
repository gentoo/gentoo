# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="virtual keyboard for X window system"
HOMEPAGE="http://t-sato.in.coocan.jp/xvkbd/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXaw3d
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/gccmakedep
	x11-misc/imake
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.6-last_altgr_mask.patch

	epatch_user
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) LD=$(tc-getCC) \
		XAPPLOADDIR="/usr/share/X11/app-defaults" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		CDEBUGFLAGS="${CFLAGS}"
}

src_install() {
	emake \
		XAPPLOADDIR="/usr/share/X11/app-defaults" \
		DESTDIR="${D}" \
		install

	rm -r "${D}"/usr/$(get_libdir) "${D}"/etc || die

	dodoc README
	newman ${PN}.man ${PN}.1
}
