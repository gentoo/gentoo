# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="A program to split non-css dvd vobs into individual chapters"
HOMEPAGE="http://www.maven.de/code"
SRC_URI="http://files.digital-digest.com/downloads/files/encode/vStrip_${PV/./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-gentoo.patch
	edos2unix *.c *.h

	local f
	for f in *.c *.h ; do
		echo >> "${f}" || die
	done

	default
}

src_compile() {
	emake CFLAGS="${CFLAGS} -D__UNIX__" CC="$(tc-getCC)"
}

src_install() {
	dobin vstrip
}
