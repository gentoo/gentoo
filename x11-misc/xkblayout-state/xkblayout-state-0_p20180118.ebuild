# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

# Commit Date: 18 Jan 2018
EGIT_COMMIT="45b752b130e077d5b1437d40b0a459e062aafa13"

DESCRIPTION="A small program to get/set the current XKB layout"
HOMEPAGE="https://github.com/nonpop/xkblayout-state"
SRC_URI="https://github.com/nonpop/xkblayout-state/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
}
