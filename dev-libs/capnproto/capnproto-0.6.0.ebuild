# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

DESCRIPTION="RPC/Serialization system with capabilities support"
HOMEPAGE="http://capnproto.org"
SRC_URI="https://github.com/sandstorm-io/capnproto/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/060"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="static-libs test"

RDEPEND=""
DEPEND="test? ( dev-cpp/gtest )"

S=${WORKDIR}/${P}/c++

src_prepare() {
	sed -e 's/ldconfig/true/' -i Makefile.am || die
	sed -e 's#gtest/lib/libgtest.la gtest/lib/libgtest_main.la#-lgtest -lgtest_main#' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
