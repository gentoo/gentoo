# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="Nyancat in your terminal, rendered through ANSI escape sequences"
HOMEPAGE="https://nyancat.dakko.us/"
SRC_URI="https://github.com/klange/nyancat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin src/${PN}
	doman ${PN}.1
	einstalldocs
	systemd_dounit systemd/${PN}{.socket,@.service}
}
