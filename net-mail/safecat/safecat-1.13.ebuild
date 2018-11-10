# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Safecat implements qmail's maildir algorithm, safely copying standard input"
HOMEPAGE="http://www.jeenyus.net/linux/software/safecat.html"
SRC_URI="http://www.jeenyus.net/linux/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc ~sparc x86"
IUSE=""
RESTRICT="test"

DEPEND="sys-apps/groff"
RDEPEND=""

PATCHES=(
	# applying maildir-patch
	"${FILESDIR}"/safecat-1.11-gentoo.patch
	# Fix parallel make errors
	"${FILESDIR}"/${P}-makefile.patch
	# Fix POSIX head/tail syntax
	"${FILESDIR}"/${P}-head-tail-POSIX.patch
)

src_prepare() {
	default

	sed -ni '/man\|doc/!p' hier.c || die

	# Fix implicit decleration
	sed '/include <signal.h>/ a #include <stdlib.h>' -i safecat.c || die
}

src_configure() {
	echo "${D}/usr" > conf-root || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_install() {
	emake setup check
	einstalldocs
	doman maildir.1 safecat.1
}
