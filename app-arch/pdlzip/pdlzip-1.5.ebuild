# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pdlzip/pdlzip-1.5.ebuild,v 1.3 2014/04/07 02:34:32 naota Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Public-domain version of lzip compressor"
HOMEPAGE="http://www.nongnu.org/lzip/pdlzip.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~x86-fbsd"
IUSE=""

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
