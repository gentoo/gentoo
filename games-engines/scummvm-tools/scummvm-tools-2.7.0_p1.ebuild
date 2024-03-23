# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit desktop flag-o-matic toolchain-funcs wxwidgets xdg

DESCRIPTION="Utilities for the SCUMM game engine"
HOMEPAGE="https://www.scummvm.org/"
SRC_URI="https://www.scummvm.org/frs/scummvm-tools/${PV/_p*}/${P/_p*}.tar.xz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
	https://dev.gentoo.org/~pacho/${PN}/${PN}_512.png"
S="${WORKDIR}/${P/_p*}"

LICENSE="GPL-3+ LGPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="flac iconv mad png tremor vorbis"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}
	flac? ( media-libs/flac:= )
	iconv? (
		virtual/libiconv
		media-libs/freetype:2 )
	mad? ( media-libs/libmad )
	png? ( media-libs/libpng:= )
	tremor? ( media-libs/tremor )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	# Endianess patch synced with Fedora
	"${FILESDIR}/${PN}-2.7.0-endianess.patch"
)

src_prepare() {
	default

	# Debian patches
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done
}

src_configure() {
	# -Werror=strict-aliasing, -Werror=odr
	# https://bugs.gentoo.org/926081
	# https://bugs.scummvm.org/ticket/15039
	append-flags -fno-strict-aliasing
	filter-lto

	setup-wxwidgets
	tc-export CXX STRINGS

	# Not an autoconf script
	./configure \
		--enable-verbose-build \
		--mandir="${EPREFIX}/usr/share/man" \
		--prefix="${EPREFIX}/usr" \
		$(use_enable flac) \
		$(use_enable iconv) \
		$(use_enable iconv freetype2) \
		$(use_enable mad) \
		$(use_enable png) \
		$(use_enable tremor) \
		$(use_enable vorbis) || die
}

src_install() {
	default
	cd "${ED}"/usr/bin || die
	for i in $(ls * | grep -v scummvm-tools) ; do
		mv ${i} ${PN}-${i} || die
	done

	make_desktop_entry ${PN} "ScummVM Tools" ${PN} "Game;AdventureGame;"
	newicon -s 128 "${S}"/gui/media/scummvmtools_128.png ${PN}.png
	newicon -s 512 "${DISTDIR}"/${PN}_512.png ${PN}.png
}
