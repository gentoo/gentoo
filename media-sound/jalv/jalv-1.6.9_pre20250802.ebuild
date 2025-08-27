# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson qmake-utils xdg

DESCRIPTION="Simple but fully featured LV2 host for Jack"
HOMEPAGE="https://drobilla.net/software/jalv.html"
if [[ ${PV} == *_p* ]] ; then
	COMMIT=7e87c29f5f8a1526c13fc6592732c10406c2621e
	SRC_URI="https://gitlab.com/drobilla/jalv/-/archive/${COMMIT}/${P}-${COMMIT:0:8}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT}"
else
	SRC_URI="https://download.drobilla.net/${P}.tar.xz"
fi

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk +jack portaudio qt6 test"
REQUIRED_USE="^^ ( jack portaudio )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/serd-0.32.2
	>=dev-libs/sord-0.16.6
	>=dev-libs/zix-0.7.0_pre20250801
	media-libs/lilv
	media-libs/lv2
	media-libs/sratom
	media-libs/suil
	gtk? ( x11-libs/gtk+:3 )
	jack? ( virtual/jack )
	portaudio? ( media-libs/portaudio )
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md )

src_configure() {
	use qt6 && export PATH="$(qt6_get_bindir):${PATH}"

	local emesonargs=(
		-Dqt5=disabled
		-Dman=enabled
		-Dman_html=disabled
		$(meson_feature gtk gtk3)
		$(meson_feature jack)
		$(meson_feature portaudio)
		$(meson_feature qt6)
		$(meson_feature test tests)
	)
	meson_src_configure
}
