# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="C++ library providing a simple API to read and write INI-style files"
HOMEPAGE="https://github.com/brofield/simpleini/"
SRC_URI="https://github.com/brofield/simpleini/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="test? ( virtual/pkgconfig )"

src_compile() {
	if use test; then
		append-cppflags $($(tc-getPKG_CONFIG) --cflags gtest_main || die)
		append-ldflags $(test-flags-CCLD -pthread)
		append-libs $($(tc-getPKG_CONFIG) --libs gtest_main || die)
		local emakeargs=(
			{CC,CXX}="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CPPFLAGS="${CPPFLAGS}"
			LDFLAGS="${LDFLAGS} ${LIBS}"
		)
		emake -C tests "${emakeargs[@]}"
	fi
}

src_install() {
	# note: skipping ConvertUTF, can use -DSI_CONVERT_ICU instead if needed
	doheader SimpleIni.h
	einstalldocs
}
