# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/hanterm/hanterm-3.1.6-r4.ebuild,v 1.6 2014/07/05 00:25:41 naota Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Hanterm -- Korean terminal"
HOMEPAGE="http://www.hanterm.org/"
SRC_URI="http://download.kldp.net/hanterm/${P}.tar.gz"

LICENSE="MIT HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="utempter"

DEPEND="x11-libs/libXmu
	x11-libs/libICE
	x11-libs/libXaw
	utempter? ( sys-libs/libutempter )
	>=x11-libs/libXaw3d-1.5"
RDEPEND="${DEPEND}
	media-fonts/baekmuk-fonts"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch" \
		"${FILESDIR}"/${P}-utmp.patch
	sed -i -e "/^LDFLAGS/s:=:& ${LDFLAGS} :" \
		-e "s:\$(CFLAGS):& \$(LDFLAGS) :" Makefile.in
}

src_configure() {
	econf \
		--with-Xaw3d \
		$(use_with utempter)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin hanterm || die

	insinto /usr/share/X11/app-defaults
	newins Hanterm.ad Hanterm.orig
	newins "${FILESDIR}/Hanterm.gentoo" Hanterm

	newman hanterm.man hanterm.1

	dohtml doc/devel/hanterm.html doc/devel/3final.gif

	dodoc README ChangeLog doc/{AUTHORS,THANKS,TODO}
	dodoc doc/devel/hanterm.sgml
	dodoc doc/historic/{ChangeLog*,DGUX.note,README*}
}
