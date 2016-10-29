# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils pax-utils

DESCRIPTION="General purpose, multi-paradigm programming language in the Lisp-Scheme family."
HOMEPAGE="http://racket-lang.org/"
SRC_URI="minimal? ( http://download.racket-lang.org/installers/${PV}/${PN}-minimal-${PV}-src-builtpkgs.tgz ) !minimal? ( http://download.racket-lang.org/installers/${PV}/${P}-src-builtpkgs.tgz )"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +futures +jit minimal +places +threads +X"
REQUIRED_USE="futures? ( jit )"

# see bug 426316: racket/draw (which depends on cairo) is sometimes used in compile-time code or when rendering documentation
RDEPEND="dev-db/sqlite:3
	x11-libs/cairo[X?]
	virtual/libffi"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default
	#remove bundled libraries
	rm -rf foreign/libffi/ || die "Bundled libraries libffi was not removed"
}

src_configure() {
# according to vapier, we should use the bundled libtool
# such that we don't preclude cross-compile. Thus don't use
# --enable-lt=/usr/bin/libtool
	econf \
		$(use_enable X gracket) \
		$(use_enable doc docs) \
		--enable-shared \
		$(use_enable jit) \
		--enable-foreign \
		$(use_enable places) \
		$(use_enable futures) \
		--enable-float \
		--enable-libffi \
		$(use_enable threads pthread)
}

src_compile() {
	if use jit; then
		pushd racket
		emake cgc
		pax-mark m .libs/racketcgc
		emake 3m
		pax-mark m .libs/racket3m
		popd
	fi
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	if ! use minimal; then
		#racket now comes with desktop files, but DESTDIR is mishandled
		for f in /usr/share/applications/{drracket,slideshow}.desktop; do
			sed -e "s|${D}||g" \
				-i "${D}/${f}" || die "Failed to patch '${f}'"
		done
	fi
}
