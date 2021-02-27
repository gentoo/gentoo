# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library and tools to parse, encode and handle WBXML documents"
HOMEPAGE="https://github.com/libwbxml/libwbxml"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/expat
	virtual/libiconv"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

DOCS=( BUGS ChangeLog README References THANKS TODO )
S=${WORKDIR}/${PN}-${P}

src_configure() {
	local mycmakeargs=(
		-DENABLE_INSTALL_DOC=OFF
		-DENABLE_UNIT_TEST=$(usex test)
	)

	cmake_src_configure
}
