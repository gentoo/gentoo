# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

# for live ebuilds uncomment inherit git, comment SRC_URI and empty KEYWORDS

inherit eutils
#inherit git-2

DESCRIPTION="General purpose, multi-paradigm programming language in the Lisp-Scheme family."
HOMEPAGE="http://racket-lang.org/"
SRC_URI="http://download.racket-lang.org/installers/${PV}/${PN}/${P}-src-unix.tgz"
#SRC_URI="http://pre.racket-lang.org/installers/plt-${PV}-src-unix.tgz"
EGIT_REPO_URI="git://git.racket-lang.org/plt.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="backtrace cairo doc futures jit places plot threads X"

RDEPEND="dev-db/sqlite:3 x11-libs/cairo[X?] virtual/libffi"

# see bug 426316: racket/draw (which depends on cairo) is sometimes used in compile-time code or when rendering documentation
DEPEND="${RDEPEND} x11-libs/cairo !dev-tex/slatex"

EGIT_SOURCEDIR="${WORKDIR}/${P}"
S="${WORKDIR}/${P}/src"

src_prepare() {
	#remove bundled libraries
	rm -rf foreign/libffi/

	sed -e "s,docdir=\"\${datadir}/${PN}/doc,docdir=\"\${datadir}/doc/${PF}," -i configure || die
}

src_configure() {
# according to vapier, we should use the bundled libtool
# such that we don't preclude cross-compile. Thus don't use
# --enable-lt=/usr/bin/libtool
	econf \
		$(use_enable X gracket) \
		$(use_enable plot) \
		$(use_enable doc docs) \
		--enable-shared \
		$(use_enable jit) \
		--enable-foreign \
		$(use_enable places) \
		$(use_enable futures) \
		$(use_enable backtrace) \
		$(use_enable threads pthread) \
		--disable-perl \
		$(use_with X x)
}

src_compile() {
	emake || die
}

src_install() {
	# deal with slatex
	insinto /usr/share/texmf/tex/latex/slatex/
	doins ../collects/slatex/slatex.sty

	emake DESTDIR="${D}" install || die "emake install failed"

	if use X; then
		newicon ../collects/icons/PLT-206.png drracket.png
		make_desktop_entry drracket "DrRacket" drracket "Development"
	fi
}
