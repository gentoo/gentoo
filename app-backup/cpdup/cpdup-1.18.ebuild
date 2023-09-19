# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A comprehensive filesystem mirroring program"
HOMEPAGE="http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://apollo.backplane.com/FreeSrc/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="threads"

PATCHES=( "${FILESDIR}"/${PN}-1.11-unused.patch )

src_prepare() {
	default

	cp "${FILESDIR}"/Makefile.linux Makefile || die
	# bits/stat.h has __unused too
	sed -i 's/__unused/__cpdup_unused/' *.c || die
	echo "#define strlcpy(a,b,c) strncpy(a,b,c)" >> cpdup.h || die
}

src_configure() {
	tc-export CC
	use threads || MAKEOPTS+=" NOPTHREADS=1"
}

src_install() {
	dobin cpdup
	doman cpdup.1
	dodoc -r scripts
}
