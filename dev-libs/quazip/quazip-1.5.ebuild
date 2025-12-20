# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"
SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
# SONAME of libquazip1-qt6.so, check QUAZIP_LIB_SOVERSION in CMakeLists.txt
SLOT="0/1.5"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="bzip2 test"

RESTRICT="!test? ( test )"

# bzip2 is linked against, so no app-alternatives
RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qt5compat:6
	virtual/minizip:=
	bzip2? ( app-arch/bzip2:= )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6[network] )
"

src_configure() {
	local mycmakeargs=(
		-DQUAZIP_QT_MAJOR_VERSION=6
		-DQUAZIP_ENABLE_TESTS=$(usex test)
		-DQUAZIP_BZIP2=$(usex bzip2)
	)
	cmake_src_configure
}
