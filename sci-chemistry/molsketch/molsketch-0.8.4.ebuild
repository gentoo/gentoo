# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg

DESCRIPTION="Drawing tool for 2D molecular structures"
HOMEPAGE="https://molsketch.sourceforge.io/ https://github.com/hvennekate/Molsketch/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/Molsketch/${P^}-src.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openbabel"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtsvg:6
	openbabel? ( >=sci-chemistry/openbabel-3:= )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DMSK_OBABELIFACE="$(usex openbabel)"
		-DMSK_QT6=ON
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	use openbabel && optfeature "wikiquery support through openbabel inchi interface" "sci-chemistry/openbabel[inchi]"
}
