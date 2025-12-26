# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GTEST_PV="1.8.1"

DESCRIPTION="High-performance, high-quality video filters for the GPU"
HOMEPAGE="https://movit.sesse.net/"
# Tests need gtest sources, makefile unconditionally builds tests, so ... yey!
SRC_URI="https://movit.sesse.net/${P}.tar.gz
	https://github.com/google/googletest/archive/refs/tags/release-${GTEST_PV}.tar.gz -> ${PN}-googletest-${GTEST_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"

# no sane way to use OpenGL from within tests?
RESTRICT="test"

RDEPEND="media-libs/mesa[X(+)]
	>=dev-cpp/eigen-3.2.0:=
	media-libs/libepoxy[egl(+),X]
	>=sci-libs/fftw-3:=
	media-libs/libsdl2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.3-gcc12.patch
)

src_compile() {
	GTEST_DIR="${WORKDIR}/googletest-release-${GTEST_PV}/googletest" emake
}

src_test() {
	GTEST_DIR="${WORKDIR}/googletest-release-${GTEST_PV}/googletest" emake check
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
