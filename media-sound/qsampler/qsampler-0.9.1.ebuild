# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake qmake-utils xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/qsampler/code"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="Graphical frontend to the LinuxSampler engine"
HOMEPAGE="https://qsampler.sourceforge.io/ https://www.linuxsampler.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +libgig"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib
	media-libs/liblscp:=
	x11-libs/libX11
	libgig? ( media-libs/libgig:= )
"
RDEPEND="${DEPEND}
	media-sound/linuxsampler
"
BDEPEND="dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}/${P}-cmake-no-git.patch"
)

DOCS=( AUTHORS ChangeLog README TODO TRANSLATORS )

src_prepare() {
	cmake_src_prepare

	sed -e "/^find_package.*QT/s/Qt6 //" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_LIBGIG=$(usex libgig 1 0)
	)
	cmake_src_configure
}
