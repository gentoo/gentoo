# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId=35e800d81f28c632956c5a592e3cbe8085ecd430
DESCRIPTION="C++ Native Object Protocols"
HOMEPAGE="https://github.com/google/libnop"
SRC_URI="https://github.com/google/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

src_compile() {
	use test && default
}

src_install() {
	doheader -r include/nop
	einstalldocs
}

src_test() {
	out/test || die
}
