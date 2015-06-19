# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvdisaster/dvdisaster-0.72.4.ebuild,v 1.7 2012/09/26 11:11:08 ssuominen Exp $

EAPI=4
inherit eutils gnome2-utils toolchain-funcs

DESCRIPTION="Data-protection and recovery tool for DVDs"
HOMEPAGE="http://dvdisaster.sourceforge.net/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug nls"

dvdi_langs="cs de it pt_BR ru sv"
for dvdi_lang in ${dvdi_langs}; do
	IUSE+=" linguas_${dvdi_lang}"
done
unset dvdi_lang

RDEPEND="app-arch/bzip2
	>=dev-libs/glib-2.20
	media-libs/libpng:0
	sys-libs/zlib
	>=x11-libs/gtk+-2.14:2"
DEPEND="${RDEPEND}
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
	dobin tools/pngpack

	newdoc tools/README README.pngpack
	dodoc CHANGELOG CREDITS.en README* TODO *HOWTO

	newicon contrib/${PN}48.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN} 'System;Utility'

	local res
	for res in 16 32 48 64; do
		newicon -s ${res} contrib/${PN}${res}.png ${PN}.png
	done

	local dest="${ED}"/usr/share

	local dvdi_lang
	for dvdi_lang in ${dvdi_langs}; do
		use linguas_${dvdi_lang} || rm -rf \
			${dest}/doc/${PF}/${dvdi_lang} \
			${dest}/doc/${PF}/CREDITS.${dvdi_lang} \
			${dest}/man/${dvdi_lang}
	done

	rm -f "${ED}"/usr/bin/*-uninstall.sh
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
