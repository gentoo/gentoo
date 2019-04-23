# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

DESCRIPTION="Trace TCP/UDP/... sessions and fetch application data."
HOMEPAGE="http://chaosreader.sourceforge.net
	https://github.com/brendangregg/Chaosreader"
SRC_URI="https://dev.gentoo.org/~spock/portage/distfiles/${P}.bz2"
SLOT="0"

KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
LICENSE="GPL-2+"

IUSE=""

DEPEND=">=dev-lang/perl-5.8.0"
S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/chaosreader-0.94-zombies.patch
	epatch "${FILESDIR}"/chaosreader-0.94-chunkcheck.patch
	epatch "${FILESDIR}"/chaosreader-0.94-darwin.patch
	epatch "${FILESDIR}"/chaosreader-0.94-divisionbyzero.patch
	epatch "${FILESDIR}"/chaosreader-0.94-oldmultiline.patch
}

src_install() {
	newbin ${P} chaosreader
}
