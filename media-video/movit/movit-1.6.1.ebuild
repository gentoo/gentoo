# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

# no sane way to use OpenGL from within tests?
RESTRICT="test"

DESCRIPTION="Modern Video Toolkit"
HOMEPAGE="https://movit.sesse.net/"
# Tests need gtest, makefile unconditionally builds tests, so ... yey!
SRC_URI="https://movit.sesse.net/${P}.tar.gz
	https://googletest.googlecode.com/files/gtest-1.7.0.zip"
LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/mesa[X(+)]
	>=dev-cpp/eigen-3.2.0:3
	media-libs/libepoxy
	>=sci-libs/fftw-3
	media-libs/libsdl2
	"
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_compile() {
	GTEST_DIR="${WORKDIR}/gtest-1.7.0" emake
}

src_test() {
	GTEST_DIR="${WORKDIR}/gtest-1.7.0" emake check
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
