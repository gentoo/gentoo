# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Hash cracker that precomputes plaintext - ciphertext pairs in advance"
HOMEPAGE="http://project-rainbowcrack.com/"
SRC_URI="amd64? ( http://project-${PN}.com/${P}-linux64.zip )
	x86? ( http://project-${PN}.com/${P}-linux32.zip )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="bindist mirror" #444426

RAINBOW_DESTDIR="opt/${PN}"

QA_FLAGS_IGNORED="${RAINBOW_DESTDIR}/.*"
QA_PRESTRIPPED="${RAINBOW_DESTDIR}/.*"

DEPEND="app-arch/unzip"

src_unpack() {
	unpack ${A}
	mv ${P}-linux* "${S}"
}

src_install() {
	local bin bins="rcrack rt2rtc rtc2rt rtgen rtsort"

	exeinto "/${RAINBOW_DESTDIR}"
	doexe alglib0.so ${bins}

	for bin in ${bins}; do
		make_wrapper ${bin} ./${bin} "/${RAINBOW_DESTDIR}" "/${RAINBOW_DESTDIR}"
	done

	insinto "/${RAINBOW_DESTDIR}"
	doins charset.txt

	dodoc readme.txt
}
