# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Compression program for large files"
HOMEPAGE="https://rzip.samba.org/"
SRC_URI="https://rzip.samba.org/ftp/rzip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

RDEPEND="app-arch/bzip2:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1-darwin.patch
	"${FILESDIR}"/${PN}-2.1-CVE-2017-8364.patch
	"${FILESDIR}"/${PN}-2.1-configure-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	ewarn "Warning: Gentoo shipped a broken rzip for quite some time. During"
	ewarn "compression of large files it didn't set the right file size, so"
	ewarn "if you have any reason to believe that your archive was compressed "
	ewarn "with an old Gentoo rzip, please refer to "
	ewarn "     https://bugs.gentoo.org/217552"
	ewarn "for the rzip-handle-broken-archive.patch patch to rescue your"
	ewarn "data."
	ewarn
	ewarn "We apologize for the inconvenience."
}
