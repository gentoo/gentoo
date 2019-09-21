# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="A tool to parse smaps statistics"
HOMEPAGE="https://www.selenic.com/smem/"
SRC_URI="mirror://gentoo/smem.pl.${PV}.bz2
	https://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/smem.pl.${PV}.bz2"

IUSE=""

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-lang/perl
	dev-perl/Linux-Smaps"

src_compile() { :; }

src_install() {
	newbin smem.pl.${PV} smem || die
}
