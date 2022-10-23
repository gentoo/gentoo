# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs xdg

DESCRIPTION="Nintendo Entertainment System (NES) emulator"
HOMEPAGE="https://github.com/punesemu/puNES"
SRC_URI="https://github.com/punesemu/puNES/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}_musl.patch.xz"
S="${WORKDIR}/puNES-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg ffmpeg"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/libglvnd[X]
	virtual/glu
	virtual/udev
	x11-libs/libX11
	x11-libs/libXrandr
	cg? ( media-gfx/nvidia-cg-toolkit )
	ffmpeg? ( media-video/ffmpeg:= )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	dev-qt/linguist-tools:5
	dev-util/cmake
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}_ldflags.patch
	"${WORKDIR}"/${P}_musl.patch # 830471
)

src_prepare() {
	default

	# empty CMAKE_ARGS to avoid double CHOST (bug #877089), and also unused
	# options (QA notices), use sed to avoid rebases because of the directory
	sed -e '/x${DEBUG_VERSION}/i\CMAKE_ARGS=' \
		-i src/extra/lib7zip-*/configure || die
	tc-export CC CXX

	# src/extra/lib7zip is not autotools, but
	# is contained within AC_CONFIG_SUBDIRS
	AT_NO_RECURSIVE=1 eautoreconf
	cd src/extra/xdelta-3.1.0 || die
	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_with cg opengl-nvidia-cg)
		$(use_with ffmpeg)
	)

	econf "${econfargs[@]}"
}
