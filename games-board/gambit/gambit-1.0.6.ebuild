# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=true
MY_P="${P^}"
inherit cmake desktop

DESCRIPTION="Qt-based chess application + engine \"gupta\""
HOMEPAGE="https://sourceforge.net/projects/gambitchess/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}chess/${MY_P}/${MY_P}-source.tar.gz"
S="${WORKDIR}/${MY_P}-source"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,network,opengl,widgets]
	media-libs/mesa[X(+)]
	x11-libs/libX11"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-compile-flags.patch )

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ENABLE_UPDATE_CHECKER=OFF
		-DCONFIG_GUPTA_ENGINE_DIRECTORY=/usr/bin
		-DCONFIG_RESOURCE_PATH_PREFIX=/usr/share/${PN}/
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	emake -C engine/gupta VERBOSE=1 STRIP=/bin/true CFLAGS_RELEASE= release
}

src_install() {
	insinto /usr/share/${PN}
	doins -r data/*

	doicon artwork/icons/${PN}/${PN}.svg
	make_desktop_entry ${PN}chess ${PN^} ${PN} Game
	dodoc doc/contributors.txt

	dobin engine/gupta/gupta
	dobin ${PN}chess
}
