# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="A tool to trace TCP/UDP/... sessions and fetch application data from snoop or tcpdump logs"
HOMEPAGE="http://users.tpg.com.au/bdgcvb/chaosreader.html"
SRC_URI="https://dev.gentoo.org/~spock/portage/distfiles/${P}.bz2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
LICENSE="GPL-2"
IUSE=""
DEPEND=">=dev-lang/perl-5.8.0"
S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/chaosreader-0.94-zombies.patch
}

src_install() {
	newbin ${P} chaosreader || die
}
