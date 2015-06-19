# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/racket/racket-5.2.1.ebuild,v 1.2 2014/08/10 21:25:26 slyfox Exp $

EAPI="4"

# for live ebuilds uncomment inherit git, comment SRC_URI and empty KEYWORDS

inherit eutils
#inherit git-2

DESCRIPTION="Racket is a general-purpose programming language with strong support for domain-specific languages"
HOMEPAGE="http://racket-lang.org/"
SRC_URI="http://download.racket-lang.org/installers/${PV}/${PN}/${P}-src-unix.tgz"
#SRC_URI="http://pre.racket-lang.org/installers/plt-${PV}-src-unix.tgz"
EGIT_REPO_URI="git://git.racket-lang.org/plt.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="backtrace cairo doc futures jit places plot threads X"

RDEPEND="X? ( x11-libs/cairo[X] ) virtual/libffi"

DEPEND="${RDEPEND} !dev-tex/slatex"

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
