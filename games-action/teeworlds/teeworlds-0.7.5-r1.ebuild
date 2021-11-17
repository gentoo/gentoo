# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake desktop python-any-r1

DESCRIPTION="Online multi-player platform 2D shooter"
HOMEPAGE="https://www.teeworlds.com/"
SRC_URI="
	https://github.com/teeworlds/teeworlds/releases/download/${PV}/teeworlds-${PV}-src.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${P}-src"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug dedicated"

RDEPEND="
	!dedicated? (
		app-arch/bzip2:=
		media-libs/freetype
		media-libs/libsdl2[X,sound,opengl,video]
		media-libs/pnglite
		media-sound/wavpack
		virtual/glu
		virtual/opengl
		x11-libs/libX11
	)
	dev-libs/openssl:0=
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_configure() {
	local mycmakeargs=(
		-DCLIENT=$(usex dedicated OFF ON)
		-DDEV=$(usex debug ON OFF)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	doicon "${DISTDIR}"/${PN}.png
	domenu other/teeworlds.desktop

	newinitd "${FILESDIR}"/${PN}-init.d ${PN}

	insinto /etc/${PN}
	doins "${FILESDIR}"/teeworlds_srv.cfg
}
