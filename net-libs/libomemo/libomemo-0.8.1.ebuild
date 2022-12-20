# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Implementation of OMEMO (XEP-0384) in C"
HOMEPAGE="https://github.com/gkdr/libomemo"
SRC_URI="https://github.com/gkdr/libomemo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-db/sqlite
	dev-libs/glib
	dev-libs/libgcrypt
	dev-libs/mxml
	"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cmocka )
	"

RESTRICT="!test? ( test )"

DOCS=( CHANGELOG.md README.md )

src_configure() {
	local mycmakeargs=(
		-DOMEMO_WITH_TESTS=$(usex test)
	)
	cmake_src_configure
}
