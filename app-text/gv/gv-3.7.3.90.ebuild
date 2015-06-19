# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gv/gv-3.7.3.90.ebuild,v 1.1 2013/01/10 20:22:10 ssuominen Exp $

EAPI=5
inherit eutils

DESCRIPTION="Viewer for PostScript and PDF documents using Ghostscript"
HOMEPAGE="http://www.gnu.org/software/gv/"
# Change 'gnu-alpha' to 'gnu' for final release, like 3.7.4
SRC_URI="mirror://gnu-alpha/gv/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="xinerama"

RDEPEND="app-text/ghostscript-gpl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXaw3d-1.6-r1[unicode]
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	export ac_cv_lib_Xinerama_main=$(usex xinerama)
	econf --enable-scrollbar-code
}

src_install() {
	default
	doicon "${FILESDIR}"/gv_icon.xpm
	make_desktop_entry gv GhostView gv_icon 'Graphics;Viewer'
}
