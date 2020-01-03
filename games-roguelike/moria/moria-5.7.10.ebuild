# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD="yes"
inherit cmake prefix

DESCRIPTION="The Dungeons of Moria, a single player roguelike game, also known as Umoria"
HOMEPAGE="https://umoria.org/"
SRC_URI="https://github.com/dungeons-of-moria/umoria/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~m68k ~x86"
IUSE=""

RDEPEND="acct-group/gamestat
	>=sys-libs/ncurses-6.0:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/umoria-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-gentoo-paths.patch"
	"${FILESDIR}/${P}-tinfo.patch"
)

src_prepare() {
	cmake_src_prepare
	sed -i "s/@PF@/${PF}/" src/config.cpp || die
	hprefixify src/config.cpp
}

src_install() {
	newbin umoria/umoria moria

	insinto /usr/share/moria
	doins data/*.txt

	insinto /var/lib/moria
	doins data/scores.dat
	fowners root:gamestat /var/lib/moria/scores.dat
	fperms g+w /var/lib/moria/scores.dat

	doman "${FILESDIR}"/${PN}.6
	dodoc -r AUTHORS README.md docs

	# The game binary will look for plain text LICENSE
	insinto /usr/share/doc/${PF}
	doins LICENSE
	docompress -x /usr/share/doc/${PF}/LICENSE
}

pkg_postinst() {
	elog
	elog "Please add users to the 'gamestat' group, so they can run Moria:"
	elog "  usermod -aG gamestat <user>"
	elog
}
