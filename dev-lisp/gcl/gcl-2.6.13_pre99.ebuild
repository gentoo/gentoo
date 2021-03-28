# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit elisp-common eutils flag-o-matic

DESCRIPTION="GNU Common Lisp"
HOMEPAGE="https://www.gnu.org/software/gcl/gcl.html"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.xz"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="+ansi athena emacs +readline tk X"

# See bug #205803
RESTRICT="strip"

RDEPEND="dev-libs/gmp
	virtual/latex-base
	emacs? ( app-editors/emacs:= )
	readline? ( sys-libs/readline:= )
	athena? ( x11-libs/libXaw )
	tk? ( dev-lang/tk:= )
	X? ( x11-libs/libXt x11-libs/libXext x11-libs/libXmu x11-libs/libXaw )"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	app-text/texi2html
	>=sys-devel/autoconf-2.52"

src_configure() {
	strip-flags
	filter-flags -fstack-protector -fstack-protector-all
	# breaks linking on multiple defined syms
	#append-cflags $(test-flags-CC -fgnu89-inline)

	local tcl=""
	if use tk; then
		tcl="--enable-tclconfig=/usr/lib --enable-tkconfig=/usr/lib"
	fi

	econf --enable-dynsysgmp \
		--disable-xdr \
		--enable-emacsdir=/usr/share/emacs/site-lisp/gcl \
		$(use_enable readline) \
		$(use_enable ansi) \
		$(use_enable athena xgcl) \
		$(use_with X x) \
		${tcl}
}

src_compile() {
	emake -j1
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

	rm elisp/add-defaults.el
	dodoc readme readme.gmp readme.xgcl ChangeLog doc/* info/*.pdf
	dodoc -r info/gcl-si
	doman man/man1/gcl.1
	doinfo info/gcl.info* info/gcl-si.info

	use athena && dodoc xgcl-2/*.pdf

	if use tk; then
		dodoc -r info/gcl-tk
		doinfo info/gcl-tk.info*
	fi

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
		elisp-install ${PN} elisp/*.el
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
