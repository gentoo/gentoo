# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg-utils

DESCRIPTION="Metronome application supporting different meters and speeds ranging"
HOMEPAGE="https://www.antcom.de/gtick"
SRC_URI="https://www.antcom.de/gtick/download/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="nls sndfile"

RDEPEND="media-libs/libpulse
	virtual/libintl
	x11-libs/gtk+:2
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.5-desktop.patch
	"${FILESDIR}"/${PN}-0.5.5-autotools.patch
	"${FILESDIR}"/${PN}-0.5.5-no-dmalloc-tests.patch
)

src_prepare() {
	default

	sed -i 's:^\(appdatadir = .*/\)appdata:\1metainfo:' \
		Makefile.{am,in} || die

	eautoreconf
}

src_configure() {
	#append-cflags -std=gnu17

	local myeconfargs=(
		$(use_enable nls)
		$(use_with sndfile)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	local res

	default

	for res in 32 48 64; do
		newicon -s ${res} src/icon${res}x${res}.xpm gtick.xpm
	done
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
