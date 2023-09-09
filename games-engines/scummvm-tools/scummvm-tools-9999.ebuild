# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER=3.2-gtk3
inherit wxwidgets toolchain-funcs

DESCRIPTION="Utilities for the SCUMM game engine"
HOMEPAGE="https://www.scummvm.org/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scummvm/scummvm-tools"
else
	SRC_URI="https://www.scummvm.org/frs/scummvm-tools/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="flac iconv mp3 png vorbis"
RESTRICT="test" # some tests require external files

DEPEND="
	dev-libs/boost:=
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}
	flac? ( media-libs/flac:= )
	iconv? ( virtual/libiconv media-libs/freetype:2 )
	mp3? ( media-libs/libmad )
	png? ( media-libs/libpng:= )
	vorbis? ( media-libs/libvorbis )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.0-binprefix.patch"
	"${FILESDIR}/${PN}-2.7.0-guisuffix.patch"
)

src_prepare() {
	default

	rm -r *.bat dists/win32 || die
}

src_configure() {
	setup-wxwidgets
	tc-export CXX STRINGS

	local myconf=(
		--disable-tremor
		--enable-verbose-build
		--mandir="${EPREFIX}/usr/share/man"
		--prefix="${EPREFIX}/usr"
		$(use_enable flac)
		$(use_enable iconv)
		$(use_enable iconv freetype2)
		$(use_enable mp3 mad)
		$(use_enable png)
		$(use_enable vorbis)
	)
	echo "configure ${myconf[@]}"
	# not an autoconf script, so don't call econf
	./configure "${myconf[@]}" ${EXTRA_ECONF} || die
}

src_install() {
	EXEPREFIX="${PN}-" default

	mv "${ED}/usr/bin/scummvm-tools-scummvm-tools-cli" "${ED}/usr/bin/scummvm-tools-cli"
	mv "${ED}/usr/bin/scummvm-tools-scummvm-tools-gui" "${ED}/usr/bin/scummvm-tools-gui"
}
