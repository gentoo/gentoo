# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# no sane way to use OpenGL from within tests?
RESTRICT="test"

DESCRIPTION="Modern Video Toolkit"
HOMEPAGE="http://movit.sesse.net/"
# Tests need gtest, makefile unconditionally builds tests, so ... yey!
SRC_URI="http://movit.sesse.net/${P}.tar.gz
	https://googletest.googlecode.com/files/gtest-1.7.0.zip"
LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

RDEPEND="media-libs/mesa[X(+)]
	>=dev-cpp/eigen-3.2.0:3
	media-libs/libepoxy
	sci-libs/fftw
	media-libs/libsdl2
	"
DEPEND="${RDEPEND}"

src_compile() {
	GTEST_DIR="${WORKDIR}/gtest-1.7.0" emake
}

src_test() {
	GTEST_DIR="${WORKDIR}/gtest-1.7.0" emake check
}
