# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Microsoft's NTLM authentication (libntlm) library"
HOMEPAGE="http://www.nongnu.org/libntlm/"
SRC_URI="http://www.nongnu.org/${PN}/releases/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
