# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="A small program to get/set the current XKB layout"
HOMEPAGE="https://github.com/nonpop/xkblayout-state"
EGIT_REPO_URI="https://github.com/nonpop/xkblayout-state.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
}
