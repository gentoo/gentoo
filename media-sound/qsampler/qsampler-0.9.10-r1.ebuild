# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/qsampler/code"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Graphical frontend to the LinuxSampler engine"
HOMEPAGE="https://qsampler.sourceforge.io/ https://www.linuxsampler.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +libgig"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtsvg:6
	media-libs/alsa-lib
	media-libs/liblscp:=
	x11-libs/libX11
	libgig? ( media-libs/libgig:= )
"
RDEPEND="${DEPEND}
	media-sound/linuxsampler
"
BDEPEND="
	dev-qt/qttools:6[linguist]
"

DOCS=( ChangeLog README TRANSLATORS )

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_LIBGIG=$(usex libgig 1 0)
		-DCONFIG_QT6=1
	)
	cmake_src_configure
}
