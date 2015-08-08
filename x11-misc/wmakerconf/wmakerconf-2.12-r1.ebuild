# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="X based config tool for the windowmaker X windowmanager"
HOMEPAGE="http://wmakerconf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="imlib nls perl"

RDEPEND="x11-libs/gtk+:2
	>=x11-wm/windowmaker-0.95.2
	imlib? ( media-libs/imlib )
	perl? ( dev-lang/perl
		dev-perl/HTML-Parser
		|| ( dev-perl/libwww-perl
		www-client/lynx
		net-misc/wget ) )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-wmaker-0.95_support.patch
}

src_configure() {
	local myconf
	use imlib || myconf="--disable-imlibtest"

	econf \
		$(use_enable perl upgrade) \
		$(use_enable nls) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" gnulocaledir="${ED}/usr/share/locale" install
	dodoc AUTHORS ChangeLog MANUAL NEWS README TODO
	doman man/*.1

	rm -f "${ED}"/usr/share/${PN}/{AUTHORS,README,COPYING,NEWS,MANUAL,ABOUT-NLS,NLS-TEAM1,ChangeLog}
}

pkg_postinst() {
	elog "New features added with WindowMaker >= 0.95 will not be available in wmakerconf"
	elog "WPrefs is the recommended configuration tool"
}
