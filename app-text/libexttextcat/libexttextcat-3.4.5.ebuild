# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library implementing N-gram-based text categorization"
HOMEPAGE="http://software.wise-guys.nl/libtextcat/"
SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
