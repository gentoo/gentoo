# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit autotools wxwidgets xdg

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="http://spek.cc/"
SRC_URI="https://github.com/alexkay/spek/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=media-video/ffmpeg-5:=
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.4-disable-updates.patch
	# Debian patches
	"${FILESDIR}"/00_dfsg.patch
	"${FILESDIR}"/01_arm64-mips64el.patch
	"${FILESDIR}"/02_ftbfs-gcc13.patch
	"${FILESDIR}"/03_metainfo.patch
)

src_prepare() {
	setup-wxwidgets unicode
	default
	eautoreconf
}
