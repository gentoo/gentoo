# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool to test TCP and UDP throughput"
HOMEPAGE="
	http://ftp.arl.mil/~mike/ttcp.html
	http://www.netcore.fi/pekkas/linux/ipv6/"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~jsmolic/distfiles/${P}.c"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~sparc ~x86"

src_prepare() {
	cp "${DISTDIR}"/${P}.c ${PN}.c || die
	default
}

src_configure() {
	tc-export CC
}

src_compile() {
	emake ttcp
}

src_install() {
	dobin ttcp
	newman sgi-ttcp.1 ttcp.1
}
