# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs xdg

DESCRIPTION="Quick Image Viewer"
HOMEPAGE="https://spiegl.de/qiv/ https://codeberg.org/ciberandy/qiv"
SRC_URI="https://codeberg.org/ciberandy/qiv/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~x86"
IUSE="exif lcms"
# just a launch-test
RESTRICT="test"

RDEPEND="
	dev-libs/glib:2
	sys-apps/file
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/pango
	exif? ( media-libs/libexif )
	lcms? (
		media-libs/lcms:2
		media-libs/libjpeg-turbo:=
		media-libs/tiff:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.2-adapt_makefile.patch
)

src_prepare() {
	default

	if ! use exif ; then
		sed -i 's/^EXIF =/#\0/' Makefile || die
	fi

	if ! use lcms ; then
		sed -i 's/^LCMS =/#\0/' Makefile || die
	fi
}

src_compile() {
	tc-export CC PKG_CONFIG
	default
}

src_install() {
	local myemakeargs=(
		PREFIX="${ED}/usr"
		# do not compress the manpage
		COMPRESS_PROG=true
		# do not strip
		STRIP_FLAG=
	)
	emake "${myemakeargs[@]}" install

	dodoc Changelog contrib/qiv-command.example README README.TODO
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "GIF support" gui-libs/gdk-pixbuf[gif]
	optfeature "JPEG support" gui-libs/gdk-pixbuf[jpeg]
	optfeature "TIFF support" gui-libs/gdk-pixbuf[tiff]
	optfeature "WebP support" gui-libs/gdk-pixbuf-loader-webp
}
