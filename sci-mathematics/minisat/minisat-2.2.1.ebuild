# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
SRC_URI="https://github.com/stp/${PN}/archive/releases/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"
S="${WORKDIR}/${PN}-releases-${PV}"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
IUSE="doc"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}"

src_install() {
	cmake_src_install

	mv "${D}"/usr/lib "${D}"/usr/$(get_libdir) || die
	dosym libminisat.a /usr/$(get_libdir)/libMiniSat.a

	use doc && dodoc "${DISTDIR}"/MiniSat.pdf
}
