# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Secure file wiping utility based on Peter Gutman's patterns"
HOMEPAGE="http://wipe.sourceforge.net/"
SRC_URI="mirror://sourceforge/wipe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-LDFLAGS.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin wipe
	doman wipe.1
	einstalldocs
	dodoc TESTING
}

pkg_postinst() {
	elog "Note that wipe is useless on journaling filesystems,"
	elog "such as reiserfs, XFS, or ext3."
	elog "See documentation for more info."
}
