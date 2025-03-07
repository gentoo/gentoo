# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Safecat implements qmail's maildir algorithm, safely copying standard input"
HOMEPAGE="http://www.jeenyus.net/linux/software/safecat.html"
SRC_URI="http://www.jeenyus.net/linux/software/${PN}/${P}.tar.gz"
SRC_URI+=" mirror://gentoo/${P}-clang-fixes.patch"

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
	# Clang fixes
	"${DISTDIR}"/${P}-clang-fixes.patch
	# GCC15 fixes
	"${FILESDIR}"/safecat-1.13-gcc15.patch
	# Link fixes
	"${FILESDIR}"/safecat-1.13-ar.patch
)

src_prepare() {
	default

	sed -ni '/man\|doc/!p' hier.c || die
}

src_configure() {
	echo "/usr" > conf-root || die
	# Verified that these are safe as of 2024/12/01.
	echo "$(tc-getCC) ${CFLAGS} -Wno-discarded-qualifiers -Wno-misleading-indentation" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "$(tc-getAR)" > conf-ar || die
	echo "$(tc-getRANLIB)" > conf-ranlib || die
}

src_install() {
	# ${D} is not valid in src_configure
	# Do not use DJB compiled installer anymore
	#echo "${D}/usr" > conf-root || die
	#emake setup check
	dobin safecat maildir
	einstalldocs
	doman maildir.1 safecat.1
}
