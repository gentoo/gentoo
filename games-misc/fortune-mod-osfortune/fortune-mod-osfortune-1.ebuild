# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Open sources fortune file"
HOMEPAGE="https://web.archive.org/web/20030803031143/http://www.dibona.com/opensources/index.shtml"
SRC_URI="https://web.archive.org/web/20030919200547/http://www.dibona.com/opensources/osfortune.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
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
