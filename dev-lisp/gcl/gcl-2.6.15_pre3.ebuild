# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit elisp-common flag-o-matic

DESCRIPTION="GNU Common Lisp"
HOMEPAGE="https://www.gnu.org/software/gcl/gcl.html"
SRC_URI="http://git.savannah.gnu.org/cgit/gcl.git/snapshot/${PN}-Version_2_6_15pre3.tar.gz
	https://dev.gentoo.org/~grozin/${PF}-spelling.patch.gz"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="+ansi athena doc emacs +readline tk X"
RESTRICT="strip"  #205803

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

PATCHES=( "${WORKDIR}"/${PF}-spelling.patch )
S="${WORKDIR}"/${PN}-Version_2_6_15pre3/${PN}

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
	dodoc readme readme.gmp readme.xgcl ChangeLog doc/*

	pushd "${D}"/usr/share/doc > /dev/null
	rm dwdoc.tex || die "rm dwdoc.tex.bz2 failed"
	if use doc; then
		mv *.pdf gcl gcl-si gcl-tk dwdoc ${PF} || die "mv * ${PF} failed"
	else
		rm -rf *.pdf gcl gcl-si gcl-tk dwdoc
	fi
	popd > /dev/null

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
