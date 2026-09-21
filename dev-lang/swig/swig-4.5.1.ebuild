# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="https://www.swig.org/ https://github.com/swig/swig"
SRC_URI="https://downloads.sourceforge.net/project/swig/swig/${P}/${P}.tar.gz"

LICENSE="GPL-3+ BSD BSD-2"
SLOT="0"
# Temporarily unkeyworded due to breakage in reverse dependencies, bug #983043
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="ccache doc pcre test test-full"
RESTRICT="!test? ( test )"

RDEPEND="
	pcre? ( dev-libs/libpcre2:= )
	ccache? ( virtual/zlib:= )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/boost )
"
BDEPEND="
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		test-full? (
			dev-lang/mono
			>=dev-lang/go-1.20
			virtual/jdk
			>=dev-lang/lua-5.1:*
			dev-lang/ocaml
			dev-lang/perl:*
			|| (
				dev-lang/php:8.3
				dev-lang/php:8.2
			)
			dev-lang/R
			dev-lang/tcl
		)
	)
"

DOCS=( ANNOUNCE CHANGES CHANGES.current README TODO )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	# strict aliasing violations in test code
	filter-lto
	append-flags -fno-strict-aliasing

	local myconf=(
		PKGCONFIG="$(tc-getPKG_CONFIG)"
		--without-maximum-compile-warnings
		$(use_enable ccache)
		$(use_with pcre)
		--without-clang-format

		# tests are automagic for many languages otherwise and may be quite brittle
		--without-alllang
		--with-python # installed by default due to portage, significant portion of revdeps use swig for python bindings
	)
	if use test-full; then
		myconf+=(
			--with-csharp
			#--with-d # doesn't accept gcc[d]?
			--with-go
			#--with-guile would need guile-any type support
			--with-java
			#--with-javascript # broken build
			--with-lua
			--with-ocaml
			#--with-octave # broken build
			--with-perl
			--with-perl5="${EPREFIX}/usr/bin/perl"
			--with-php
			--with-r
			#--with-ruby # broken build
			#--with-scilab # not packaged?
			--with-tcl
		)
	fi
	econf "${myconf[@]}"
}

src_compile() {
	# Override these variables per Makefile.in to get verbose logs
	emake FLAGS="-k" RUNPIPE=""
}

src_test() {
	# The tests won't get run w/o an explicit call, broken Makefiles?
	# *-sections for bug #935318
	emake check \
		FLAGS="-k" \
		RUNPIPE="" \
		CFLAGS="${CFLAGS} -ffunction-sections -fdata-sections" \
		CXXFLAGS="${CXXFLAGS} -ffunction-sections -fdata-sections" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r Doc/{Devel,Manual}
	fi
}
