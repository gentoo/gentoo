# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="YANG data modeling language library"
HOMEPAGE="https://github.com/CESNET/libyang"
SRC_URI="https://github.com/CESNET/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

RDEPEND="dev-libs/libpcre"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	doc? ( app-doc/doxygen[dot] )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_LYD_PRIV=yes
		-DGEN_LANGUAGE_BINDINGS=no
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	use doc && dodoc -r "${S}"/doc/*
}
