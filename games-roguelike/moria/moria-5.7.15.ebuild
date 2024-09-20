# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD="yes"
inherit cmake prefix

DESCRIPTION="The Dungeons of Moria, a single player roguelike game, also known as Umoria"
HOMEPAGE="https://umoria.org/"
SRC_URI="https://github.com/dungeons-of-moria/umoria/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/umoria-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~m68k ~x86"

RDEPEND="acct-group/gamestat
	>=sys-libs/ncurses-6.0:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-5.7.12-gentoo-paths.patch" )

src_prepare() {
	cmake_src_prepare
	hprefixify src/config.cpp
}

src_install() {
	newbin umoria/umoria moria

	insinto /usr/share/moria
	doins umoria/data/*.txt

	insinto /var/lib/moria
	doins umoria/scores.dat
	fowners root:gamestat /var/lib/moria/scores.dat /usr/bin/${PN}
	fperms g+w /var/lib/moria/scores.dat

	doman "${FILESDIR}"/${PN}.6
	dodoc -r AUTHORS CHANGELOG.md CONTRIBUTING.md README.md historical
}

pkg_postinst() {
	elog
	elog "Please add users to the 'gamestat' group, so they can run Moria:"
	elog "  usermod -aG gamestat <user>"
	elog
}
