# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P=${PN/-mod/}

DESCRIPTION="Quotes from Bart Simpson's Chalkboard, shown at the opening of Simpsons episode"
HOMEPAGE="http://www.splitbrain.org/projects/fortunes/simpsons"
SRC_URI="http://www.splitbrain.org/_media/projects/fortunes/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""
RESTRICT="mirror"

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins chalkboard chalkboard.dat
}
