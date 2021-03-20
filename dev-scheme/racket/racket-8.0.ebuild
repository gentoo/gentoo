# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils

DESCRIPTION="General purpose, multi-paradigm Lisp-Scheme programming language"
HOMEPAGE="https://racket-lang.org/"
SRC_URI="minimal? ( https://download.racket-lang.org/installers/${PV}/${PN}-minimal-${PV}-src-builtpkgs.tgz )"
SRC_URI+=" !minimal? ( https://download.racket-lang.org/installers/${PV}/${P}-src-builtpkgs.tgz )"
S="${WORKDIR}/${P}/src"

# See https://blog.racket-lang.org/2019/11/completing-racket-s-relicensing-effort.html
LICENSE="
	|| ( MIT Apache-2.0 )
	chez? ( Apache-2.0 )
	!chez? ( LGPL-3 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc +futures +jit minimal +places +readline +threads +X +chez"

REQUIRED_USE="futures? ( jit )"

RDEPEND="
	dev-db/sqlite:3
	media-libs/libpng:0
	x11-libs/cairo[X?]
	x11-libs/pango[X?]
	dev-libs/libffi
	virtual/jpeg:0
	readline? ( dev-libs/libedit )
	X? ( x11-libs/gtk+[X?] )
	!dev-tex/slatex
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	rm -r bc/foreign/libffi || die 'failed to remove bundled libffi'
}

src_configure() {
	# According to vapier, we should use the bundled libtool
	# such that we don't preclude cross-compile. Thus don't use
	# --enable-lt=/usr/bin/libtool
	# docdir doesn't get passed automatically
	econf \
		--enable-shared \
		--enable-float \
		--enable-libffi \
		--enable-foreign \
		--docdir="/usr/share/doc/${PF}" \
		$(usex chez "--enable-cs --enable-csonly" "--enable-bc --enable-bconly") \
		--disable-libs \
		--disable-strip \
		$(use_enable X gracket) \
		$(use_enable doc docs) \
		$(use_enable jit) \
		$(use_enable places) \
		$(use_enable futures) \
		$(use_enable threads pthread)
}

src_compile() {
	if use jit; then
		# When the JIT is enabled, a few binaries need to be pax-marked
		# on hardened systems (bug 613634). The trick is to pax-mark
		# them before they're used later in the build system. The
		# following order for racketcgc and racket3m was determined by
		# digging through the Makefile in src/racket to find out which
		# targets would build those binaries but not use them.
		if ! use chez; then
			pushd bc || die
			emake cgc-core
			pax-mark m .libs/racketcgc

			pushd gc2 || die
			emake all
			popd || die

			pax-mark m .libs/racket3m
			popd || die
		fi
	fi

	default
}

src_install() {
	default

	if use jit; then
		# The final binaries need to be pax-marked, too, if you want to
		# actually use them. The src_compile marking get lost somewhere
		# in the install process.
		for f in mred mzscheme racket; do
			pax-mark m "${D}/usr/bin/${f}"
		done

		use X && pax-mark m "${D}/usr/$(get_libdir)/racket/gracket"

		pax-mark m "${D}/usr/$(get_libdir)/racket/starter"
	fi

	# raco needs decompressed files for packages doc installation bug 662424
	if use doc; then
		docompress -x /usr/share/doc/${PF}
	fi

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
