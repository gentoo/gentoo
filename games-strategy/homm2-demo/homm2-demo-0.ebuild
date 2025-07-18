# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data files for HoMM II Demo version"
HOMEPAGE="https://archive.org/details/HeroesofMightandMagicIITheSuccessionWars_1020"
SRC_URI="https://archive.org/download/HeroesofMightandMagicIITheSuccessionWars_1020/h2demo.zip -> ${P}.zip"

LICENSE="HoMM2-Demo"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="games-engines/fheroes2"
RDEPEND="
	${DEPEND}
	!games-strategy/homm2-gold-gog
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/fheroes2/data
	doins DATA/*

	insinto /usr/share/fheroes2/maps
	doins MAPS/*
}

pkg_postinst() {
	elog "Run the game using ${EPREFIX}/usr/bin/fheroes2"
}
