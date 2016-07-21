# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit elisp-common eutils flag-o-matic

DESCRIPTION="GNU Common Lisp"
HOMEPAGE="https://www.gnu.org/software/gcl/gcl.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz https://dev.gentoo.org/~grozin/${P}-fedora.tar.bz2"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="+ansi athena emacs +readline tk X"

# See bug #205803
RESTRICT="strip"

RDEPEND="emacs? ( virtual/emacs )
	readline? ( sys-libs/readline )
	athena? ( x11-libs/libXaw )
	>=dev-libs/gmp-4.1
	tk? ( dev-lang/tk )
	X? ( x11-libs/libXt x11-libs/libXext x11-libs/libXmu x11-libs/libXaw )
	virtual/latex-base"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	>=app-text/texi2html-1.64
	>=sys-devel/autoconf-2.52"

S="${WORKDIR}"/${PN}

src_prepare() {
	mv "${WORKDIR}"/fedora/info/* info/
	cp -p /usr/share/texmf-dist/tex/texinfo/texinfo.tex info/
	find . -type f -perm /0111 | xargs chmod a-x
	chmod a+x add-defs add-defs1 config.guess config.sub configure install.sh
	chmod a+x bin/info bin/info1 gcl-tk/gcltksrv.in gcl-tk/ngcltksrv mp/gcclab
	chmod a+x o/egrep-def utils/replace xbin/*

	# fedora patches
	epatch "${WORKDIR}"/fedora/fd-leak.patch
	epatch "${WORKDIR}"/fedora/latex.patch
	epatch "${WORKDIR}"/fedora/texinfo.patch
	epatch "${WORKDIR}"/fedora/elisp.patch
	epatch "${WORKDIR}"/fedora/rename.patch
	epatch "${WORKDIR}"/fedora/getcwd.patch
	epatch "${WORKDIR}"/fedora/infrastructure.patch
	epatch "${WORKDIR}"/fedora/extension.patch
	epatch "${WORKDIR}"/fedora/unrandomize.patch
	epatch "${WORKDIR}"/fedora/asm-signal-h.patch
	epatch "${WORKDIR}"/fedora/plt.patch
	epatch "${WORKDIR}"/fedora/ellipsis.patch
	epatch "${WORKDIR}"/fedora/man.patch
	epatch "${WORKDIR}"/fedora/reloc-type.patch
	epatch "${WORKDIR}"/fedora/largefile.patch

	epatch "${FILESDIR}"/${PN}-tcl-8.6.patch
	epatch "${FILESDIR}"/${PN}-gmp-6.patch
	epatch "${FILESDIR}"/${PN}-readline-6.3.patch

	sed -e 's|"-fomit-frame-pointer"|""|' -i configure
	sed -e 's|@EXT@||g' debian/in.gcl.1 > gcl.1
}

src_configure() {
	strip-flags
	filter-flags -fstack-protector -fstack-protector-all

	local tcl=""
	if use tk; then
		tcl="--enable-tclconfig=/usr/lib --enable-tkconfig=/usr/lib"
	fi

	econf --enable-dynsysgmp \
		--disable-xdr \
		--enable-emacsdir=/usr/share/emacs/site-lisp/gcl \
		--enable-infodir=/usr/share/info \
		$(use_enable readline) \
		$(use_enable ansi) \
		$(use_enable athena xgcl) \
		$(use_with X x) \
		${tcl}
}

src_compile() {
	emake -j1
	emake -C info gcl.info
	if use athena; then
		pushd xgcl-2 > /dev/null
		pdflatex dwdoc.tex
		popd > /dev/null
	fi
}

src_test() {
	local make_ansi_tests_clean="rm -f test.out *.fasl *.o *.so *~ *.fn *.x86f *.fasl *.ufsl"
	if use ansi; then
		cd ansi-tests

		( make clean && make test-unixport ) \
			|| die "make ansi-tests failed!"

		cat "${FILESDIR}/bootstrap-gcl" \
			| ../unixport/saved_ansi_gcl

		cat "${FILESDIR}/bootstrap-gcl" \
			|sed s/bootstrapped_ansi_gcl/bootstrapped_r_ansi_gcl/g \
			| ./bootstrapped_ansi_gcl

		( ${make_ansi_tests_clean} && \
			echo "(load \"gclload.lsp\")" \
			| ./bootstrapped_r_ansi_gcl ) \
			|| die "Phase 2, bootstraped compiler failed in tests"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	mv "${D}"usr/share/doc/*.dvi .
	rm -rf "${D}"usr/share/doc
	rm -rf "${D}"usr/share/emacs
	rm -rf "${D}"usr/lib/gcl-*/info

	rm doc/makefile elisp/add-defaults.el
	dodoc readme* RELEASE* ChangeLog* doc/*
	doman gcl.1
	doinfo info/*.info*
	dohtml -r info/gcl-si info/gcl-tk

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
		elisp-install ${PN} elisp/*.el
	fi

	insinto /usr/share/doc/${PF}
	doins *.dvi
	if use athena; then
		pushd xgcl-2 > /dev/null
		insinto /usr/share/doc/${PF}
		doins *.pdf
		popd > /dev/null
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
