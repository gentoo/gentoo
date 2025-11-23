# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Chuck Norris Facts"
HOMEPAGE="https://www.k-lug.org/~kessler/projects.html"
SRC_URI="https://www.k-lug.org/~kessler/chucknorris.tar.gz"
S="${WORKDIR}"/${PN/mod-/}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="games-misc/fortune-mod"

src_install() {
	insinto /usr/share/fortune
	doins chucknorris chucknorris.dat
}
