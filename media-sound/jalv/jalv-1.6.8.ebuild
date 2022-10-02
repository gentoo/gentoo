# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson qmake-utils flag-o-matic xdg

DESCRIPTION="Simple but fully featured LV2 host for Jack"
HOMEPAGE="https://drobilla.net/software/jalv.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk jack portaudio qt5"

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
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
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
	use qt5 && export PATH="$(qt5_get_bindir):${PATH}"

	local emesonargs=(
		$(meson_feature gtk gtk3)
		$(meson_feature jack)
		$(meson_feature portaudio)
		$(meson_feature qt5)
	)
	meson_src_configure
}

src_compile() {
	append-flags -fPIC

	meson_src_compile
}
