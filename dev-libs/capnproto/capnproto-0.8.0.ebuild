# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="RPC/Serialization system with capabilities support"
HOMEPAGE="https://capnproto.org"
SRC_URI="https://github.com/sandstorm-io/capnproto/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/080"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ssl static-libs test zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	ssl? (
		dev-libs/openssl:0=
	)
	zlib? ( sys-libs/zlib:0= )
"
DEPEND="${RDEPEND} test? ( dev-cpp/gtest )"

S=${WORKDIR}/${P}/c++

src_prepare() {
	sed -e 's/ldconfig/true/' -i Makefile.am || die
	sed -e 's#gtest/lib/libgtest.la gtest/lib/libgtest_main.la#-lgtest -lgtest_main#' -i Makefile.am || die
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with ssl openssl) \
		$(use_with zlib)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
