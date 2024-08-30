# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="command-line tool for setting and viewing mixer settings"
HOMEPAGE="http://centerclick.org/programs/smixer"
SRC_URI="http://centerclick.org/programs/${PN}/${PN}${PV}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin smixer
	einstalldocs
	doman man/smixer.1

	insinto /etc
	doins smixer.conf
}
