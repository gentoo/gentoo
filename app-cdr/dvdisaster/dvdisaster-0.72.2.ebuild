# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils gnome2-utils versionator

MY_P=${PN}-$(replace_version_separator 2 '.')

DESCRIPTION="Data-protection and recovery tool for DVDs"
HOMEPAGE="http://dvdisaster.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE="debug linguas_cs linguas_de linguas_it linguas_ru cpu_flags_x86_sse2"

RDEPEND=">=x11-libs/gtk+-2.6:2
	media-libs/libpng
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.72.1-libpng15.patch
}

# - There is no autotools, use_ functions won't work
# - NLS disabled because sys-devel/gettext fails, if you enable it
# you need also virtual/libintl because it links to it for FreeBSD
src_configure() {
	local myconf

	if use cpu_flags_x86_sse2; then
		myconf+=" --with-sse2=yes"
	else
		myconf+=" --with-sse2=no"
	fi

	use debug && myconf+=" --with-memdebug=yes"

	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--mandir=/usr/share/man \
		--docdir=/usr/share/doc \
		--docsubdir=${PF} \
		--localedir=/usr/share/locale \
		--buildroot="${D}" \
		--with-nls=no \
		${myconf} || die
}

src_install() {
	emake install

	newicon contrib/${PN}48.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN} "System;Utility"

	for res in 16 32 48 64; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps
		newins contrib/${PN}${res}.png ${PN}.png
	done

	local dest="${D}/usr/share"

	for lang in cs de it ru; do
		use linguas_${lang} || rm -rf ${dest}/doc/${PF}/${lang} \
			${dest}/doc/${PF}/CREDITS.${lang} ${dest}/man/${lang}
	done

	rm -f "${D}"/usr/bin/*.sh
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
