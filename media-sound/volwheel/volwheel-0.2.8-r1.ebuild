# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils gnome2-utils

DESCRIPTION="A volume control trayicon with mouse wheel support"
HOMEPAGE="http://oliwer.net/b/volwheel.html"
SRC_URI="https://olwtools.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="alsa"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Gtk2
	alsa? ( media-sound/alsa-utils )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-perl516.patch
	sed -i -e '/^Encoding/d' ${PN}.desktop || die
}

src_install() {
	./install.pl prefix=/usr destdir="${D}" || die
	dodoc ChangeLog README TODO
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
