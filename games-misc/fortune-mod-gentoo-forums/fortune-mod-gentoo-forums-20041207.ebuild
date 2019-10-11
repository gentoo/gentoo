# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Fortune database of quotes from forums.gentoo.org"
HOMEPAGE="https://forums.gentoo.org/"
SRC_URI="mirror://gentoo/gentoo-forums-${PV}.gz
	offensive? ( mirror://gentoo/gentoo-forums-offensive-${PV}.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="offensive"

DEPEND="games-misc/fortune-mod"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_compile() {
	mv gentoo-forums-${PV} gentoo-forums || die
	use offensive && cat gentoo-forums-offensive-${PV} >> gentoo-forums
	strfile gentoo-forums || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-forums gentoo-forums.dat
}
