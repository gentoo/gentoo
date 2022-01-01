# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Collection of utilities for parsing Internet mail messages"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"
HOMEPAGE="http://cr.yp.to/mess822.html"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
LICENSE="public-domain"

RDEPEND=">=sys-apps/sed-4"
DEPEND="${RDEPEND}"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-implicit.patch
)

src_prepare() {
	default

	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	echo "/usr" > conf-home

	# fix errno.h problem; bug #26165
	sed -i 's/^extern int errno;/#include <errno.h>/' error.h || die

	sed -i -e "s/ar/$(tc-getAR)/" make-makelib.sh || die
	sed -i -e "s/ranlib/$(tc-getRANLIB)/" make-makelib.sh || die
}

src_install() {
	dodir /etc
	dodir /usr/share

	# Now that the commands are compiled, update the conf-home file to point
	# to the installation image directory.
	echo "${ED}/usr/" > conf-home
	sed -i -e "s:\"/etc\":\"${ED}/etc\":" hier.c || die "sed hier.c failed"

	emake setup

	# Move the man pages into /usr/share/man
	mv "${ED}/usr/man" "${ED}/usr/share/" || die

	dodir /usr/$(get_libdir)
	mv "${ED}/usr/lib/${PN}.a" "${ED}/usr/$(get_libdir)/${PN}.a" || die
	rmdir "${ED}/usr/lib" || die
	dodoc BLURB CHANGES INSTALL README THANKS TODO VERSION
}
