# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Safecat implements qmail's maildir algorithm, safely copying standard input"
HOMEPAGE="http://www.jeenyus.net/linux/software/safecat.html"
SRC_URI="http://www.jeenyus.net/linux/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ppc ~sparc ~x86"
RESTRICT="test"

DEPEND="sys-apps/groff"

PATCHES=(
	# applying maildir-patch
	"${FILESDIR}"/safecat-1.11-gentoo.patch
	# Fix parallel make errors
	"${FILESDIR}"/${P}-makefile.patch
	# Fix POSIX head/tail syntax
	"${FILESDIR}"/${P}-head-tail-POSIX.patch
	# Fix dup objects
	"${FILESDIR}"/${P}-dup-obj-makefile.patch
	# Headers
	"${FILESDIR}"/${P}-include.patch
)

src_prepare() {
	default

	sed -ni '/man\|doc/!p' hier.c || die
}

src_configure() {
	echo "/usr" > conf-root || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "$(tc-getAR)" > conf-ar || die
}

src_install() {
	# ${D} is not valid in src_configure
	echo "${D}/usr" > conf-root || die
	emake setup check
	einstalldocs
	doman maildir.1 safecat.1
}
