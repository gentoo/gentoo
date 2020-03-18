# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Chuck Norris Facts"
HOMEPAGE="https://www.k-lug.org/~kessler/projects.html"
SRC_URI="https://www.k-lug.org/~kessler/chucknorris.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/mod-/}

src_install() {
	insinto /usr/share/fortune
	doins chucknorris chucknorris.dat
}
