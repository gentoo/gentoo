# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/ https://github.com/swig/swig"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="boost ccache doc go guile java javascript lua ocaml octave npm pcre perl php python R ruby tcl test"
RESTRICT="!test? ( test )"

RDEPEND="
	boost? ( dev-libs/boost )
	ccache? ( sys-libs/zlib )
	go? ( dev-lang/go  )
	guile? ( dev-scheme/guile )
	java? ( >=virtual/jdk-11:11 )
	javascript? ( net-libs/webkit-gtk:4 )
	lua? ( dev-lang/lua )
	npm? ( net-libs/nodejs )
	ocaml? ( dev-lang/ocaml )
	octave? ( sci-mathematics/octave )
	pcre? ( dev-libs/libpcre2 )
	perl? ( dev-lang/perl )
	php? ( >=dev-lang/php-8.0.0 )
	python? (
		dev-lang/python
		dev-python/pycodestyle
	)
	R? ( dev-lang/R )
	ruby? ( dev-lang/ruby )
	tcl? ( dev-lang/tcl )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/boost )
"
BDEPEND="virtual/pkgconfig"

DOCS=( ANNOUNCE CHANGES CHANGES.current README TODO )

src_configure() {
	econf \
		PKGCONFIG="$(tc-getPKG_CONFIG)" \
		--without-maximum-compile-warnings \
		--without-alllang \
		--without-python \
		$(use_enable ccache) \
		$(use_with boost) \
		$(use_with guile) \
		$(use_with java) \
		$(use_with javascript) \
		$(use_with lua) \
		$(use_with npm) \
		$(use_with ocaml) \
		$(use_with octave) \
		$(use_with pcre) \
		$(use_with perl perl5) \
		$(use_with php) \
		$(use_with python python3) \
		$(use_with R) \
		$(use_with ruby) \
		$(use_with tcl)
}

src_test() {
	# The tests won't get run w/o an explicit call, broken Makefiles?
	# java skipped for bug #921504
	emake skip-java=true check
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r Doc/{Devel,Manual}
	fi
}
