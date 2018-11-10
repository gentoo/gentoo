# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

DESCRIPTION="Symbolic Manipulation System"
HOMEPAGE="https://www.nikhef.nl/~form/"
SRC_URI="https://github.com/vermaseren/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devref doc doxygen gmp mpi threads zlib"

RDEPEND="
	gmp? ( dev-libs/gmp:0= )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	devref? ( dev-texlive/texlive-latex )
	doc? ( dev-texlive/texlive-latex )
	doxygen? ( app-doc/doxygen )"

src_prepare() {
	sed -i 's/LINKFLAGS = -s/LINKFLAGS =/' sources/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-scalar \
		--enable-largefile \
		--disable-debug \
		--disable-static-link \
		--with-api=posix \
		$(use_with gmp ) \
		$(use_enable mpi parform ) \
		$(use_enable threads threaded ) \
		$(use_with zlib ) \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_compile() {
	default
	if use devref; then
		pushd doc/devref > /dev/null || die "doc/devref does not exist"
		LANG=C emake pdf
		popd > /dev/null
	fi
	if use doc; then
		pushd doc/manual > /dev/null || die "doc/manual does not exist"
		LANG=C emake pdf
		popd > /dev/null
	fi
	if use doxygen; then
		pushd doc/doxygen > /dev/null || die "doc/doxygen does not exist"
		emake html
		popd > /dev/null
	fi
}

src_install() {
	default
	if use devref; then
		insinto /usr/share/doc/${PF}
		doins doc/devref/devref.pdf
	fi
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/manual/manual.pdf
	fi
	if use doxygen; then
		dohtml -r doc/doxygen/html/*
	fi
}
