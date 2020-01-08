# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Open sources fortune file"
HOMEPAGE="http://www.dibona.com/opensources/index.shtml"
SRC_URI="http://www.dibona.com/opensources/osfortune.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="games-misc/fortune-mod"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/spelling.patch
	strfile osfortune || die
}

src_install() {
	insinto /usr/share/fortune
	doins osfortune osfortune.dat
}
