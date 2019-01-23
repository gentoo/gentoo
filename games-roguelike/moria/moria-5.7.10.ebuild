# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD="yes"
inherit cmake-utils

DESCRIPTION="The Dungeons of Moria, a single player roguelike game, also known as Umoria"
HOMEPAGE="https://umoria.org/"
SRC_URI="https://github.com/dungeons-of-moria/umoria/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=sys-libs/ncurses-6.0:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/umoria-${PV}"

PATCHES=( "${FILESDIR}/${P}-gentoo-paths.patch" )

src_prepare() {
	cmake-utils_src_prepare
	sed -i "s/@PF@/${PF}/" src/config.cpp || die
}

src_install() {
	newbin umoria/umoria moria

	insinto /usr/share/moria
	doins data/*.txt

	insinto /var/lib/moria
	doins data/scores.dat
	fowners root:games /var/lib/moria/scores.dat
	fperms g+w /var/lib/moria/scores.dat

	doman "${FILESDIR}"/${PN}.6
	dodoc -r AUTHORS README.md docs

	# The game binary will look for plain text LICENSE
	insinto /usr/share/doc/${PF}
	doins LICENSE
	docompress -x /usr/share/doc/${PF}/LICENSE
}
