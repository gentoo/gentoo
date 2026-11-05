# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic xdg edos2unix

DESCRIPTION="Fast-paced multiplayer deathmatch game"
HOMEPAGE="https://www.alienarena.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alienarena/alienarena.git"
else
	SRC_URI="
		https://github.com/alienarena/alienarena/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2 free-noncomm"
SLOT="0"
IUSE="dedicated +dga +vidmode +zlib"

RDEPEND="
	!dedicated? (
		media-libs/freetype:2
		media-libs/libvorbis
		media-libs/openal
		net-misc/curl
		media-libs/libjpeg-turbo:=
		virtual/glu
		virtual/opengl
		dga? ( x11-libs/libXxf86dga )
		vidmode? ( x11-libs/libXxf86vm )
		zlib? ( virtual/zlib:= )
	)"
DEPEND="${RDEPEND}
	!dedicated? (
		dga? ( x11-base/xorg-proto )
		vidmode? ( x11-base/xorg-proto )
	)"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-7.66-ar.patch
	"${FILESDIR}"/${P}-lto-type-mismatch.patch
)

src_prepare() {
	edos2unix source/client/{qmenu.c,menu.c} source/game/game.h source/qcommon/qcommon.h

	default
	eautoreconf
}

src_configure() {
	# too many variables defined in .h to patch, https://bugs.gentoo.org/707814
	append-cflags -fcommon

	econf \
		--with-icondir="${EPREFIX}/usr/share/icons/hicolor/48x48/apps/" \
		--without-system-libode \
		--disable-documents \
		$(use_enable !dedicated client) \
		$(use_with zlib) \
		$(use_with vidmode xf86vm) \
		$(use_with dga xf86dga)
}

src_install() {
	DOCS=( docs/README.txt unix_dist/README )
	default

	use !dedicated && make_desktop_entry ${PN} "Alien Arena"
}
