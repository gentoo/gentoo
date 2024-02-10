# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs xdg-utils

DESCRIPTION="X-based rich text editor"
HOMEPAGE="https://www.nllgg.nl/Ted/"
SRC_URI="ftp://ftp.nluug.nl/pub/editors/ted/${P}.src.tar.gz"
S="${WORKDIR}/Ted-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv sparc x86"

RDEPEND="
	app-text/libpaper:=
	dev-libs/libpcre2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	sys-libs/zlib
	virtual/libiconv
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/motif
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/lsb-release
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-0001-pass-MAKE-to-subdir.patch
	"${FILESDIR}"/${P}-0002-fix-unrecognized-option-with-GTK.patch
	"${FILESDIR}"/${P}-0003-avoid-compressing-man-page.patch
	"${FILESDIR}"/${P}-freetype261.patch
	"${FILESDIR}"/${P}-use-Motif-toolkit-instead-of-GTK-by-default.patch
)

src_prepare() {
	default

	sed -i -e 's|/Ted/|/share/Ted/|' \
		"${S}"/appFrame/appFrameConfig.h.in \
		"${S}"/Ted/tedConfig.h.in || die

	# bug #461256
	find . -name makefile.in -exec sed -i -e '/ar r/s/ar/$(AR)/' {} \; || die

	# force to build dynamic binary, do not strip it
	sed -i \
		-e 's/.static//g' \
		-e '/strip/d' \
		tedPackage/makefile.in || die 'sed failed on tedPackage/makefile.in'

	# Fix build with freetype-2.5
	sed -i "s|^\(#[ \t]*include[ \t]*<\)freetype/|\1|" appFrame/appFontConfig.c || die

	mkdir lib || die
}

src_configure() {
	tc-export AR CC RANLIB

	local dir
	for dir in appUtil textEncoding utilPs bitmap docFont docBase docBuf ind drawMeta docRtf docEdit docLayout docHtml; do
		cd "${S}"/${dir} || die
		econf --cache-file=../config.cache
	done
	for dir in appFrame; do
		cd "${S}"/${dir} || die
		econf --cache-file=../config.cache --with-MOTIF
	done
}

src_compile() {
	emake package.shared
}

src_install() {
	default
	dosym ../share/Ted/examples/rtf2pdf.sh /usr/bin/rtf2pdf.sh
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
