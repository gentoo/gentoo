# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="C++ library of mathematical, signal processing and communication"
HOMEPAGE="https://itpp.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE="doc"

RDEPEND="sci-libs/fftw:3.0=
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? (
		app-text/doxygen
		virtual/latex-base
	)"

DOCS=( ChangeLog NEWS AUTHORS README )

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.1-use-GNUInstallDirs.patch
	"${FILESDIR}"/${P}-cmake.patch
)

src_configure() {
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DBLA_VENDOR=Generic
		-DHTML_DOCS=$(usex doc)
	)

	cmake_src_configure
}
