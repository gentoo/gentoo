# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils gnome2-utils

DESCRIPTION="Alf's PDF Viewer Like Vim"
HOMEPAGE="https://naihe2010.github.com/apvlv/"
SRC_URI="https://github.com/naihe2010/apvlv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug djvu html"

RDEPEND="
	>=app-text/poppler-0.18:=[cairo,xpdf-headers(+)]
	dev-libs/glib:2
	x11-libs/gtk+:3
	djvu? ( app-text/djvu:= )
	html? ( net-libs/webkit-gtk:3= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# preserve cflags
	epatch "${FILESDIR}/${PN}-0.1.5-cflags.patch"
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONFDIR=/etc/${PN}
		-DDOCDIR=/usr/share/${PN}
		-DMANDIR=/usr/share/man
		$(cmake-utils_use html APVLV_WITH_HTML)
		-DAPVLV_WITH_UMD=OFF
		-DAPVLV_WITH_TXT=ON
		$(cmake-utils_use djvu APVLV_WITH_DJVU)
		$(cmake-utils_use debug APVLV_ENABLE_DEBUG)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS NEWS README THANKS TODO
	newicon -s 32 icons/pdf.png ${PN}.png
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
