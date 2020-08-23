# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Easy-to-use chart creation library for PHP"
HOMEPAGE="https://naku.dohcrew.com/libchart https://github.com/naku/libchart"
SRC_URI="https://github.com/naku/${PN}/releases/download/release/${PV}/${P}.tar.gz"

LICENSE="GPL-3 BitstreamVera"
KEYWORDS="~amd64 ~x86"
SLOT=0
IUSE="examples"

DEPEND=""
RDEPEND="dev-lang/php:*[gd,truetype]"

S="${WORKDIR}/${PN}"

src_install() {
	dodoc "${PN}"/{ChangeLog,README}

	if use examples ; then
		# PHP won't run a compressed example...
		docompress -x "/usr/share/doc/${PF}/demo"
		dodoc -r demo/
	fi

	insinto "/usr/share/php/${PN}"
	doins -r "${PN}"/{classes,fonts,images}
}
