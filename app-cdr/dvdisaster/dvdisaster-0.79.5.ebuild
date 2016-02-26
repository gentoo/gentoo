# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils toolchain-funcs

DESCRIPTION="Tool for creating error correction data (ecc) for optical media (DVD, CD, BD)"
HOMEPAGE="http://dvdisaster.net/"
SRC_URI="http://dvdisaster.net/downloads/${PN}-${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug nls"

dvdi_langs="cs de it pt_BR ru sv"
for dvdi_lang in ${dvdi_langs}; do
	IUSE+=" linguas_${dvdi_lang}"
done
unset dvdi_lang

RDEPEND=">=dev-libs/glib-2.32
	nls? ( virtual/libintl )
	>=x11-libs/gtk+-2.6:2
	x11-libs/gdk-pixbuf"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/os-headers
	virtual/pkgconfig"

src_configure() {
	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--mandir=/usr/share/man \
		--docdir=/usr/share/doc \
		--docsubdir=${PF} \
		--localedir=/usr/share/locale \
		--buildroot="${D}" \
		--with-nls=$(usex nls) \
		--with-memdebug=$(usex debug) || die
}

src_compile() {
	emake $(use nls && echo -j1) CC="$(tc-getCC)"
}

src_install() {
	emake install
	dodoc CHANGELOG CREDITS.en README* TODO *HOWTO

	newicon contrib/${PN}48.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN} 'System;Utility'

	local res
	for res in 16 32 48 64; do
		newicon -s ${res} contrib/${PN}${res}.png ${PN}.png
	done

	local dest="${D}"usr/share

	local dvdi_lang
	for dvdi_lang in ${dvdi_langs}; do
		use linguas_${dvdi_lang} || rm -rf \
			${dest}/doc/${PF}/${dvdi_lang} \
			${dest}/doc/${PF}/CREDITS.${dvdi_lang} \
			${dest}/man/${dvdi_lang}
	done

	rm -f "${D}"usr/bin/*-uninstall.sh
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
