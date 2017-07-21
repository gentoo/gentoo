# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils

DESCRIPTION="General purpose, multi-paradigm Lisp-Scheme programming language"
HOMEPAGE="http://racket-lang.org/"
SRC_URI="minimal? ( http://download.racket-lang.org/installers/${PV}/${PN}-minimal-${PV}-src-builtpkgs.tgz ) !minimal? ( http://download.racket-lang.org/installers/${PV}/${P}-src-builtpkgs.tgz )"

# The main license is LGPL-3, as described here:
#
#   https://download.racket-lang.org/license.html
#
# However, there are traces of plain-GPL code, such as the routines in
# collects/file/gzip.rkt that were based on GPLed C code, or the Cygwin
# code in src/racket/dynsrc/init.cc. To err on the side of correctness,
# we list GPL-3+, too.
#
LICENSE="GPL-3+ LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +futures +jit minimal +places +threads +X"
REQUIRED_USE="futures? ( jit )"

# According to the Racket README, the dependencies of racket/draw should
# only be needed at runtime, unless you're building the documentation:
#
#   http://docs.racket-lang.org/draw/libs.html
#
# However, we have one report where the build system tried to use Pango,
# even with USE="-doc". To be safe, we require the racket/draw
# dependencies unconditionally at both build- and run-time.
#
# References:
#
#   * bug 426316
#   * bug 486016
#
# The Racket GUI has some additional dependencies,
#
#   http://docs.racket-lang.org/gui/libs.html
#
# that may truly be runtime-only.
#
RDEPEND="dev-db/sqlite:3
	media-libs/libpng:0
	x11-libs/cairo[X?]
	x11-libs/pango[X?]
	virtual/libffi
	virtual/jpeg:0
	X? ( x11-libs/gtk+[X?] )"

# The blocker on dev-tex/slatex is because they both ship a "slatex"
# executable. The slatex that comes with racket is apparently a copy of
# dev-tex/slatex that has been modified to support only mzscheme. It's
# not clear if dev-tex/slatex can be used as a replacement for the
# racket version, but the racket version almost certainly cannot replace
# dev-tex/slatex.
#
# If dev-tex/slatex will work for racket, then maybe we could just pull
# it in as a dependency and remove /usr/bin/slatex in the src_install
# for racket. Otherwise, we may have to rename racket's version to
# somethine like slatex-racket, assuming that doesn't break
# anything. This is all bug 547398.
#
RDEPEND="${RDEPEND} !dev-tex/slatex"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default
	rm -r foreign/libffi || die 'failed to remove bundled libffi'
}

src_configure() {
	# According to vapier, we should use the bundled libtool
	# such that we don't preclude cross-compile. Thus don't use
	# --enable-lt=/usr/bin/libtool
	econf \
		--enable-shared \
		--enable-float \
		--enable-libffi \
		--enable-foreign \
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
		pushd racket
		emake cgc-core
		pax-mark m .libs/racketcgc
		pushd gc2
		emake all
		popd
		pax-mark m .libs/racket3m
		popd
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
	fi
}
