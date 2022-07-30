# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

DESCRIPTION="Image viewers for the framebuffer console (fbi) and X11 (ida)"
HOMEPAGE="https://www.kraxel.org/blog/linux/fbida/"
SRC_URI="
	https://www.kraxel.org/releases/${PN}/${P}.tar.gz
	mirror://gentoo/ida.png.bz2
"
LICENSE="GPL-2 IJG"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="curl fbcon ghostscript +gif lirc +png scanner +tiff X +webp"
REQUIRED_USE="
	ghostscript? ( tiff )
"

CDEPEND="
	!media-gfx/fbi
	>=media-libs/fontconfig-2.2
	>=media-libs/freetype-2.0
	app-text/poppler
	media-libs/libepoxy
	media-libs/libexif
	virtual/jpeg:*
	virtual/ttf-fonts
	x11-libs/cairo[opengl]
	curl? ( net-misc/curl )
	fbcon? (
		app-text/poppler[cairo]
		media-libs/mesa[X(+),gbm(+)]
		x11-libs/libdrm
		x11-libs/pixman
	)
	gif? ( media-libs/giflib:= )
	lirc? ( app-misc/lirc )
	png? ( media-libs/libpng:* )
	scanner? ( media-gfx/sane-backends )
	tiff? ( media-libs/tiff:* )
	webp? ( media-libs/libwebp )
	X? (
		>=x11-libs/motif-2.3:0[xft]
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXt
	)
"

DEPEND="
	${CDEPEND}
	X? ( x11-base/xorg-proto )
"

RDEPEND="
	${CDEPEND}
	ghostscript? (
		app-text/ghostscript-gpl
	)
"
PATCHES=(
	"${FILESDIR}"/ida-desktop.patch
	"${FILESDIR}"/${PN}-2.10-giflib-4.2.patch
	"${FILESDIR}"/${PN}-2.14-Autoconf.patch
	"${FILESDIR}"/${PN}-2.14-fno-common.patch
	"${FILESDIR}"/${PN}-2.14-cpp.patch
)

src_configure() {
	tc-export CC CPP

	# Let autoconf do its job and then fix things to build fbida
	# according to our specifications
	emake Make.config

	gentoo_fbida() {
		local useflag=${1}
		local config=${2}

		local option="no"
		use ${useflag} && option="yes"

		sed -i \
			-e "s|HAVE_${config}.*|HAVE_${config} := ${option}|" \
			"${S}/Make.config" || die
	}

	gentoo_fbida X MOTIF
	gentoo_fbida curl LIBCURL
	gentoo_fbida fbcon LINUX_FB_H
	gentoo_fbida gif LIBUNGIF
	gentoo_fbida lirc LIBLIRC
	gentoo_fbida ghostscript LIBTIFF
	gentoo_fbida png LIBPNG
	gentoo_fbida scanner LIBSANE
	gentoo_fbida tiff LIBTIFF
	gentoo_fbida webp LIBWEBP
}

src_compile() {
	emake verbose=yes
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		STRIP="" \
		prefix=/usr \
		install

	dodoc README

	if use fbcon && ! use ghostscript; then
		rm \
			"${ED}"/usr/bin/fbgs \
			"${ED}"/usr/share/man/man1/fbgs.1 \
			|| die
	fi

	if use X ; then
		doicon "${WORKDIR}"/ida.png
		domenu desktop/ida.desktop
	fi
}
