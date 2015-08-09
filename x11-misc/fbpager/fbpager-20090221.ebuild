# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="A Pager for fluxbox"
HOMEPAGE="http://git.fluxbox.org/fbpager.git/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ~sparc x86 ~x86-fbsd"
IUSE="+xrender"

DEPEND="x11-libs/libX11
	xrender? ( x11-libs/libXrender )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable xrender)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
}

pkg_postinst() {
	einfo "To run fbpager inside the FluxBox slit, use fbpager -w"
}
