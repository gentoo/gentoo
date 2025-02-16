# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="pcc portable c compiler"
HOMEPAGE="http://pcc.ludd.ltu.se"

SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/pcc-libs-${PV}
	dev-libs/libbsd"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-multiarch.patch"
	"${FILESDIR}/${P}-C23.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	econf --disable-stripping
}

src_test() {
	cc/cc/pcc --version || die # basic test that compiler runs
}
