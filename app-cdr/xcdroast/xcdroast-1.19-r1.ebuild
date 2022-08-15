# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Lightweight cdrtools front-end for CD and DVD writing"
HOMEPAGE="http://www.xcdroast.org/"
SRC_URI="mirror://sourceforge/xcdroast/${P/_/}.tar.gz"
S="${WORKDIR}"/${P/_/}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls suid"

RDEPEND=">=app-cdr/cdrtools-3.02_alpha09
	media-libs/alsa-lib
	>=x11-libs/gtk+-2:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable suid user-host-mode)
}

src_install() {
	default

	dodoc -r AUTHORS ChangeLog README doc/*

	newicon -s 48 xpms/ico_cdwriter.xpm xcdroast.xpm
	make_desktop_entry xcdroast "X-CD-Roast" xcdroast "AudioVideo;DiscBurning"
}
