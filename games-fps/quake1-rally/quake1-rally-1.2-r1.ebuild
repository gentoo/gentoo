# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix

DESCRIPTION="TC which turns Quake into a Rally racing game"
HOMEPAGE="http://wiki.quakeworld.nu/Quake_Rally"
SRC_URI="http://ehall.freeshell.org/quake/qr$(ver_rs 1-2 '').zip
	http://ehall.freeshell.org/quake/qrlo1.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror bindist"

BDEPEND="app-arch/unzip"

src_unpack() {
	einfo "Unpacking qr12.zip to ${PWD}"
	unzip -qoLL "${DISTDIR}"/qr12.zip || die "unpacking qr12.zip failed"

	einfo "Unpacking qrlo1.zip to ${PWD}"
	unzip -qoLL "${DISTDIR}"/qrlo1.zip || die "unpacking qrlo1.zip failed"

	rm -f button.wav qrally.exe || die
	cd rally || die

	edos2unix $(find . -name '*.txt' -o -name '*.cfg' || die)
	mv rally{,.example}.cfg || die
}

src_install() {
	insinto /usr/share/quake1
	doins -r *
}
