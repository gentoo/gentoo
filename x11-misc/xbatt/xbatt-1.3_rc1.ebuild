# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xbatt/xbatt-1.3_rc1.ebuild,v 1.1 2015/08/05 18:02:52 sping Exp $

EAPI=2

inherit versionator eutils toolchain-funcs

MY_PV=${PV/_rc/pr}
DESCRIPTION="Notebook battery indicator for X"
HOMEPAGE="http://www.clave.gr.jp/~eto/xbatt/"
SRC_URI="http://www.clave.gr.jp/~eto/xbatt/${PN}-${MY_PV}.tar.gz"

LICENSE="xbatt"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libxkbfile
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-misc/imake"

S="${WORKDIR}"/${PN}-$(get_version_component_range 1-2)

src_prepare(){
	epatch "${FILESDIR}"/${PN}-1.2.1-implicits.patch
}

src_compile() {
	xmkmf || die
	emake xbatt CDEBUGFLAGS="${CFLAGS}" CC="$(tc-getCC)" \
		EXTRA_LDOPTIONS="${LDFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README* || die
}
