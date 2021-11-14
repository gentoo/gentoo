# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

# no tests available
RESTRICT="test"

DESCRIPTION="Heirloom Bourne Shell, derived from OpenSolaris code SVR4/SVID3"
HOMEPAGE="http://heirloom.sourceforge.net/sh.html"
SRC_URI="mirror://sourceforge/heirloom/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-glibc-2.34.patch"
)

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake \
		"CFLAGS=${CFLAGS}" \
		"CPPFLAGS=${CPPFLAGS}" \
		"LDFLAGS=${LDFLAGS}" \
		"LARGEF=" \
		"CC=$(tc-getCC)"
}

src_install() {
	exeinto /bin
	newexe sh jsh
	newman sh.1 jsh.1
}
