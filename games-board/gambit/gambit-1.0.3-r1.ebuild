# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_IN_SOURCE_BUILD=true
inherit cmake-utils

MY_P="${P^}"

DESCRIPTION="Qt-based chess application + engine \"gupta\""
HOMEPAGE="https://sourceforge.net/projects/gambitchess/"
SRC_URI="mirror://sourceforge/project/${PN}chess/${MY_P}/${MY_P}-src.tar.bz2"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	media-libs/mesa
	x11-libs/libX11"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}-src"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ENABLE_UPDATE_CHECKER=OFF
		-DCONFIG_GUPTA_ENGINE_DIRECTORY=/usr/bin
		-DCONFIG_RESOURCE_PATH_PREFIX=/usr/share/${PN}/
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
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
