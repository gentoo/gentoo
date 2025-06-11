# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="A graphical music visualization plugin similar to milkdrop"
HOMEPAGE="https://github.com/projectM-visualizer/projectm"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/projectM-visualizer/projectm.git"
	inherit git-r3
else
	MY_PV="${PV/_/-}"
	SRC_URI="https://github.com/projectM-visualizer/projectm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/projectm-${MY_PV}/"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"
fi

LICENSE="LGPL-2"
SLOT="0/2"
IUSE="gles2 jack pulseaudio qt5 sdl"
REQUIRED_USE="
	jack? ( qt5 )
	pulseaudio? ( qt5 )
"

RDEPEND="
	media-libs/glm
	media-libs/libglvnd[X(+)]
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	sdl? ( >=media-libs/libsdl2-2.0.5 )
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-missing-gl-header.patch" # bug 792204
	"${FILESDIR}/${P}-cxx14.patch"
)

src_prepare() {
	default
	# bug 940300
	cp "${BROOT}"/usr/share/aclocal/ax_have_qt.m4 m4/autoconf-archive/ax_have_qt.m4 || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gles2 gles)
		$(use_enable jack)
		$(use_enable pulseaudio)
		$(use_enable qt5 qt)
		$(use_enable sdl)
		--enable-emscripten=no
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name '*.a' -delete || die
}
