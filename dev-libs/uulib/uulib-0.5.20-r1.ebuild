# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

MY_P=uudeview-${PV}

DESCRIPTION="Library that supports Base64 (MIME), uuencode, xxencode and binhex coding"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ~ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}/${MY_P}/${PN}

src_prepare() {
	epatch "${FILESDIR}/${P}-shared.patch"
	sed -i 's:\<ar\>:$(AR):' Makefile.in || die
	tc-export AR CC RANLIB
}
