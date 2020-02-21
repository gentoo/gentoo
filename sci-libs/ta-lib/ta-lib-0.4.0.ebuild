# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Technical Analysis Library for analyzing financial markets trends"
HOMEPAGE="http://www.ta-lib.org/"
SRC_URI="mirror://sourceforge/ta-lib/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-asneeded.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_test() {
	src/tools/ta_regtest/ta_regtest || die
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
