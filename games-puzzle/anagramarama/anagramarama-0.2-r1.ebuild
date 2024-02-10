# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs vcs-clean

DESCRIPTION="Create as many words as you can before the time runs out"
HOMEPAGE="http://www.coralquest.com/anagramarama/"
SRC_URI="http://www.omega.clara.net/anagramarama/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2"
RDEPEND="${DEPEND}
	sys-apps/miscfiles"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-fhs.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	ecvs_clean
}

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	newbin ag ${PN}

	insinto "/usr/share/${PN}"
	doins wordlist.txt
	doins -r images/ audio/

	dodoc readme

	make_desktop_entry ${PN} "Anagramarama"
}
