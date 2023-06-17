# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="A library that can collect configuration options from command line arguments"
HOMEPAGE="https://github.com/mhekkel/libmcfp"
SRC_URI="https://github.com/mhekkel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTING="$(usex test)"
	)
	cmake_src_configure
}
