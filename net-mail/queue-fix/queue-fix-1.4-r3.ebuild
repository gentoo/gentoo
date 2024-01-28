# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fixheadtails toolchain-funcs

DESCRIPTION="Qmail Queue Repair Application with support for big-todo"
HOMEPAGE="http://www.netmeridian.com/e-huss/"
SRC_URI="http://www.netmeridian.com/e-huss/${P}.tar.gz
	http://qmail.org/queue-fix-todo.patch"

LICENSE="all-rights-reserved public-domain" # includes code from qmail
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ~s390 sparc x86"
RESTRICT="mirror bindist"

PDEPEND="virtual/qmail"

PATCHES=(
	"${DISTDIR}"/queue-fix-todo.patch
	"${FILESDIR}"/${P}-stdlib.patch
	"${FILESDIR}"/${P}-errno.patch
)

src_unpack() {
	default
	ht_fix_file "${S}"/Makefile*
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	sed -e "s#'ar #'$(tc-getAR) #" -e "s#'ranlib #'$(tc-getRANLIB) #" -i make-makelib.sh || die
}

src_install() {
	dobin queue-fix

	einstalldocs
}
