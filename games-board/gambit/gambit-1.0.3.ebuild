# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

CMAKE_IN_SOURCE_BUILD=true
inherit cmake-utils games

# Switch to ^ when we switch to EAPI=6.
MY_P="G${P:1}"

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
		-DCONFIG_GUPTA_ENGINE_DIRECTORY="${GAMES_BINDIR}"/
		-DCONFIG_RESOURCE_PATH_PREFIX="${GAMES_DATADIR}"/${PN}/
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	emake -C engine/gupta VERBOSE=1 STRIP=/bin/true CFLAGS_RELEASE= release || die
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/* || die

	doicon artwork/icons/${PN}/${PN}.svg
	# Switch to ^ when we switch to EAPI=6.
	make_desktop_entry ${PN}chess G${PN:1} ${PN} Game || die
	dodoc doc/contributors.txt || die

	dogamesbin engine/gupta/gupta || die
	dogamesbin ${PN}chess || die
}
