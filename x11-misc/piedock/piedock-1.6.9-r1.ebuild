# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A little bit like the famous OS X dock but in shape of a pie menu"
HOMEPAGE="
	http://markusfisch.de/PieDock
	https://github.com/markusfisch/PieDock
"
SRC_URI="https://github.com/markusfisch/PieDock/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/PieDock-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	media-libs/libpng:0=
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXrender
	gtk? (
		>=app-accessibility/at-spi2-core-2.46.0
		dev-libs/glib
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
	)
"
DEPEND="${RDEPEND}"

DOCS=( res/${PN}rc.sample AUTHORS ChangeLog NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-signals.patch
	"${FILESDIR}"/${PN}-1.6.9-freetype_pkgconfig.patch
	"${FILESDIR}"/${PN}-1.6.9-gcc12-time.patch
	"${FILESDIR}"/${PN}-1.6.9-clang16-register-narrowing.diff
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gtk)
		--disable-kde
		--bindir="${EPREFIX}"/usr/bin
		--enable-xft
		--enable-xmu
		--enable-xrender
	)
	econf "${myeconfargs[@]}"
}
