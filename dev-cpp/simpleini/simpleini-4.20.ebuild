# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

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

PATCHES=(
	"${FILESDIR}"/${PN}-4.20-pkgconfig-var.patch
)

src_compile() {
	if use test; then
		tc-export CXX PKG_CONFIG
		emake -C tests "${emakeargs[@]}"
	fi
}

src_install() {
	# note: this skips ConvertUTF, can use -DSI_CONVERT_ICU instead if needed
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	einstalldocs
}
