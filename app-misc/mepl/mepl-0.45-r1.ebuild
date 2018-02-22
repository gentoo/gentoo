# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Self-employed-mode software for 3COM/USR message modems"
HOMEPAGE="https://web.archive.org/web/20031204100644/http://www.hof-berlin.de:80/mepl/"
SRC_URI="http://www.hof-berlin.de/mepl/mepl${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

S="${WORKDIR}/${PN}${PV}"

PATCHES=( "${FILESDIR}/${P}-gcc433.patch" )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -DMEPLCONFIG=\\\"/etc/mepl.conf\\\" ${LDFLAGS}" en
}

src_install() {
	dobin "${PN}" "${PN}mail"
	insinto /etc
	doins "${PN}.conf"
	newman "${PN}.en" "${PN}.7"
}
