# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Database of the Italian cookies for the fortune program"
HOMEPAGE="http://www.fortune-it.net/"
SRC_URI="http://www.fortune-it.net/download/fortune-it-${PVR}.tar.gz"
S="${WORKDIR}"/fortune-it-${PVR}

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="offensive"

DEPEND="games-misc/fortune-mod"

src_prepare() {
	default

	if ! use offensive ; then
		rm -f testi/*-o || die
	fi
}

src_compile() {
	local f
	for f in testi/* ; do
		strfile -s ${f} || die "strfile ${f} failed"
	done
}

src_install() {
	insinto /usr/share/fortune
	doins testi/*
	dodoc README
}
