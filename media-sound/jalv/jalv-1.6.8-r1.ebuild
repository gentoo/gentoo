# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson flag-o-matic xdg

DESCRIPTION="Simple but fully featured LV2 host for Jack"
HOMEPAGE="https://drobilla.net/software/jalv.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64"
IUSE="gtk +jack portaudio test"
REQUIRED_USE="^^ ( jack portaudio )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/serd
	dev-libs/sord
	media-libs/lilv
	media-libs/lv2
	media-libs/sratom
	media-libs/suil
	gtk? ( x11-libs/gtk+:3 )
	jack? ( virtual/jack )
	portaudio? ( media-libs/portaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}-qt5-fPIC.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_feature gtk gtk3)
		$(meson_feature jack)
		$(meson_feature portaudio)
		-Dqt5=disabled
		$(meson_feature test tests)
	)
	meson_src_configure
}

src_compile() {
	append-flags -fPIC

	meson_src_compile
}
