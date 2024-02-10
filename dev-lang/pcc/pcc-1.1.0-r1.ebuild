# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="pcc portable c compiler"
HOMEPAGE="http://pcc.ludd.ltu.se"

SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/pcc-libs-${PV}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-multiarch.patch )

src_prepare() {
	default
	sed -i \
		-e 's/AC_CHECK_PROG(strip,strip,yes,no)//' \
		-e 's/AC_SUBST(strip)//' configure.ac || die
	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	econf --disable-stripping
}
