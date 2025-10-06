# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop flag-o-matic meson toolchain-funcs xdg

COMMIT_HASH="3db896c0f3d60372cbd20467a4debb5a3620ad20"
DESCRIPTION="Image viewers for the framebuffer console (fbi) and X11 (ida)"
HOMEPAGE="https://www.kraxel.org/blog/linux/fbida/"
SRC_URI="
	https://github.com/kraxel/fbida/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/ida.png.bz2
"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="GPL-2+ IJG"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="fbcon +gif pdf +png systemd +tiff +webp X"

RDEPEND="
	dev-libs/libinput:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libexif
	media-libs/libjpeg-turbo:=
	virtual/libudev
	virtual/ttf-fonts
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
	fbcon? (
		dev-libs/glib:2
		dev-libs/libtsm:=
	)
	gif? ( media-libs/giflib:= )
	pdf? (
		!app-text/fbpdf
		app-text/poppler[cairo]
	)
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	webp? ( media-libs/libwebp:= )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/motif[xft]
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/ida-desktop.patch
	"${FILESDIR}"/${PN}-2.14-rm_automagic.patch
	"${FILESDIR}"/${PN}-2.14-cpp.patch
	"${FILESDIR}"/${PN}-2.14-libtsm4.patch
	"${FILESDIR}"/${PN}-2.14-fix_c23.patch
)

src_configure() {
	# 955090
	append-cppflags -DHAVE_PROTOTYPES

	export CPP="$(tc-getCPP)"
	local emesonargs=(
		$(meson_feature fbcon)
		$(meson_feature gif)
		$(meson_feature X motif)
		$(meson_feature pdf)
		$(meson_feature png)
		$(meson_feature systemd)
		$(meson_feature tiff)
		$(meson_feature webp)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	dodoc Changes README.{ida,md} TODO

	doicon "${WORKDIR}"/ida.png
	domenu desktop/ida.desktop
}
