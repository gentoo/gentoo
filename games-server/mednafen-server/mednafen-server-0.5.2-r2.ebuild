# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Server for Mednafen emulator"
HOMEPAGE="https://mednafen.github.io/releases/"
SRC_URI="https://mednafen.github.io/releases/files/${P}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	mv standard.conf standard.conf.example || die
	mv run.sh run.sh.example || die
}

src_install() {
	dobin src/${PN}
	dodoc README *.example
}

pkg_postinst() {
	einfo "Example config file and run file can be found in"
	einfo "/usr/share/doc/${PF}/"
}
