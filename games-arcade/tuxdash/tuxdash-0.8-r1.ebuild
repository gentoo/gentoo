# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A simple BoulderDash clone"
HOMEPAGE="http://www.tuxdash.de/index.php?language=EN"
SRC_URI="http://www.tuxdash.de/ressources/downloads/${PN}_src_${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.8-fix-c++14.patch
	"${FILESDIR}"/${PN}-0.8-fix-paths.patch
)

src_prepare() {
	default
	rm -f GPL TuxDash || die
}

src_configure() {
	tc-export CXX
}

src_compile() {
	emake -C src
}

src_install() {
	dobin tuxdash
	einstalldocs

	insinto /usr/share/${PN}
	doins -r themes maps fonts savegames config
}
