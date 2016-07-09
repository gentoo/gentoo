# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2-utils

DESCRIPTION="Lightweight cdrtools front-end for CD and DVD writing"
HOMEPAGE="http://www.xcdroast.org/"
SRC_URI="mirror://sourceforge/xcdroast/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls suid"

RDEPEND=">=x11-libs/gtk+-2:2
	app-cdr/cdrtools"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/${P/_/}

PATCHES=(
	"${FILESDIR}"/cdda2wav_version.patch
	"${FILESDIR}"/fix_cddb_hidden_tracks.patch
	"${FILESDIR}"/io_compile.patch
	"${FILESDIR}"/io_progressbar_fix.patch
	"${FILESDIR}"/suid-perms.patch
	"${FILESDIR}"/disable_version_check.patch
	"${FILESDIR}"/format-security.patch
)

src_prepare() {
	default

	# fix Norwegian locales
	mv po/{no,nb}.po || die
	mv po/{no,nb}.gmo || die
	sed -i -e 's/no/nb/' po/LINGUAS || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable suid nonrootmode) \
		--enable-gtk2 \
		--disable-dependency-tracking \
		--mandir=/usr/share/man \
		--sysconfdir=/etc
}

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	dodoc -r AUTHORS ChangeLog README doc/*

	insinto /usr/share/icons/hicolor/48x48/apps
	newins xpms/xcdricon.xpm xcdroast.xpm

	make_desktop_entry xcdroast "X-CD-Roast" xcdroast "AudioVideo;DiscBurning"
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
