# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

# Note: Please check if upstream want 2.x and so on to be slotted when released.
if ver_test ${PV} -ge 2.0 ; then
	# Sanity check to avoid naive copy-bumps
	# Upstream expect parallel installation of 0.x/1.x/2.x/...
	# https://github.com/stachenov/quazip/blob/master/QuaZip-1.x-migration.md
	die "Upstream want 0.x, 1.x, 2.x, ... to be slotted"
fi

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"
SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	sys-libs/zlib[minizip]
"
DEPEND="
	${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-conditional-tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DQUAZIP_ENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use test && cmake_src_compile qztest
}
