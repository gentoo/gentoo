# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Technical Analysis Library for analyzing financial markets trends"
HOMEPAGE="https://www.ta-lib.org/"
SRC_URI="mirror://sourceforge/ta-lib/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-slibtool.patch # 790770
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862936
	# Upstream is sourceforge plus has not been active since 2013. No bug filed.
	filter-lto

	default
}

src_test() {
	src/tools/ta_regtest/ta_regtest || die
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
