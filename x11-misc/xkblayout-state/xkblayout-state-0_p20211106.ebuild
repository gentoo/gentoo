# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# Commit Date: 06 Nov 2021
EGIT_COMMIT="f311779ed95f43f1fdebed0f710ad84057e6fe19"

DESCRIPTION="Small program to get/set the current XKB layout"
HOMEPAGE="https://github.com/nonpop/xkblayout-state"
SRC_URI="https://github.com/nonpop/xkblayout-state/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
}
