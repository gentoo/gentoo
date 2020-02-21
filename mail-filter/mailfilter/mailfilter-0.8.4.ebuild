# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mailfilter is a utility to get rid of unwanted spam mails"
HOMEPAGE="http://mailfilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="libressl +ssl"

DEPEND="sys-devel/flex
	ssl? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= )
)"

RDEPEND=""

PATCHES=( "${FILESDIR}"/0.8.4-fix-parallel-build.patch )

src_configure() {
	econf $(use_with ssl openssl)
}

src_install() {
	default
	dodoc INSTALL doc/FAQ "${FILESDIR}"/rcfile.example{1,2}
}
