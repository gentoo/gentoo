# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
SRC_URI="https://github.com/stp/${PN}/archive/releases/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"
S="${WORKDIR}/${PN}-releases-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_install() {
	cmake_src_install
	use doc && dodoc "${DISTDIR}"/MiniSat.pdf
}
