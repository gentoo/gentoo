# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Commandline tool to take screenshots of the desktop"
HOMEPAGE="https://github.com/naelstrof/maim"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/naelstrof/maim.git"
else
	SRC_URI="https://github.com/naelstrof/maim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+ MIT"
SLOT="0"
IUSE="icu"

DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/libwebp:=
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-misc/slop-7.5:=
	icu? ( dev-libs/icu:= )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMAIM_UNICODE=$(usex icu)
	)
	cmake_src_configure
}
