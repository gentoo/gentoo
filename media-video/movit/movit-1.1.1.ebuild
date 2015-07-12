# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/movit/movit-1.1.1.ebuild,v 1.2 2015/07/12 00:53:58 patrick Exp $

EAPI=5

# no sane way to use OpenGL from within tests?
RESTRICT="test"

DESCRIPTION="Modern Video Toolkit"
HOMEPAGE="http://movit.sesse.net/"
# Tests need gtest, makefile unconditionally builds tests, so ... yey!
SRC_URI="http://movit.sesse.net/${P}.tar.gz
	http://googletest.googlecode.com/files/gtest-1.7.0.zip"
LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/mesa
	dev-cpp/eigen:3
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
