# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utilities for use with qmail, typically as part of .qmail command processing"
HOMEPAGE="http://www.superscript.com/qtools/intro.html"
SRC_URI="http://www.superscript.com/qtools/${P}.tar.gz"

LICENSE="all-rights-reserved public-domain" # includes code from qmail
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~mips ppc ~sparc x86"
IUSE="static"
RESTRICT="mirror bindist"

PATCHES=(
	"${FILESDIR}"/${P}-errno.patch
	"${FILESDIR}"/${P}-head.patch
)

src_configure() {
	use static && LDFLAGS="${LDFLAGS} -static"
	export CC="$(tc-getCC)"
	echo "${CC} ${CFLAGS}" > conf-cc || die
	echo "${CC} ${LDFLAGS}" > conf-ld || die
	echo "/usr" > conf-home || die
}

src_install() {
	dobin 822addr 822body 822bodyfilter 822fields 822headerfilter \
		822headerok 822headers checkaddr checkdomain \
		condtomaildir filterto ifaddr iftoccfrom replier \
		replier-config tomaildir

	dodoc BAPVERSION CHANGES FILES README SYSDEPS TARGETS TODO VERSION
}
