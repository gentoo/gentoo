# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="X based config tool for the windowmaker X windowmanager"
HOMEPAGE="http://wmakerconf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls perl"

RDEPEND="x11-libs/gtk+:2
	>=x11-wm/windowmaker-0.95.2
	perl? ( dev-lang/perl
		dev-perl/HTML-Parser
		|| ( dev-perl/libwww-perl
		www-client/lynx
		net-misc/wget ) )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-wmaker-0.95_support.patch
)

src_prepare() {
	sed -e "/^LIBS =/s/$/ -lX11/" -i src/Makefile.in || die
	default
}

src_configure() {
	econf \
		--disable-imlibtest \
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
