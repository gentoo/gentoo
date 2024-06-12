# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Forensic tool to find hidden processes and TCP/UDP ports by rootkits/LKMs"
HOMEPAGE="https://www.unhide-forensics.info"
SRC_URI="https://github.com/YJesus/Unhide/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/Unhide-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	edo $(tc-getCC) ${CFLAGS} ${LDFLAGS} --static -pthread \
		unhide-linux*.c unhide-output.c -o unhide
	edo $(tc-getCC) ${CFLAGS} ${LDFLAGS} --static \
		unhide-tcp.c unhide-tcp-fast.c unhide-output.c -o unhide-tcp
}

src_install() {
	dobin ${PN}
	dobin ${PN}-tcp
	dodoc changelog README.txt TODO LEEME.txt LISEZ-MOI.TXT NEWS TODO
	doman man/unhide.8 man/unhide-tcp.8
	has "fr" ${LINGUAS} && newman man/fr/unhide.8 unhide.fr.8
	has "es" ${LINGUAS} && newman man/es/unhide.8 unhide.es.8
}
