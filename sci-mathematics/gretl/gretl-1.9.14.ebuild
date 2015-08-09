# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_EINSTALL=true

inherit eutils elisp-common toolchain-funcs

DESCRIPTION="Regression, econometrics and time-series library"
HOMEPAGE="http://gretl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="accessibility cpu_flags_x86_avx emacs gnome gtk nls odbc openmp python
	readline cpu_flags_x86_sse2 R static-libs"

CDEPEND="
	dev-libs/glib:2
	dev-libs/gmp
	dev-libs/libxml2:2
	dev-libs/mpfr
	sci-libs/fftw:3.0
	sci-visualization/gnuplot
	virtual/lapack
	virtual/latex-base
	accessibility? ( app-accessibility/flite )
	emacs? ( virtual/emacs )
	gtk? (
			media-libs/gd[png]
			sci-visualization/gnuplot[gd]
			x11-libs/gtk+:3
			x11-libs/gtksourceview:3.0 )
	odbc? ( dev-db/unixODBC )
	R? ( dev-lang/R )
	readline? ( sys-libs/readline )"
RDEPEND="${CDEPEND}
	python? ( dev-python/numpy )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

SITEFILE=50${PN}-gentoo.el

REQUIRED_USE="emacs? ( gtk )"

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp
	then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		die "Need an OpenMP capable compiler"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-readline.patch
}

src_configure() {
	econf \
		--disable-rpath \
		--enable-shared \
		--with-mpfr \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable gtk gui) \
		$(use_enable gtk gtk3) \
		$(use_enable gtk xdg) \
		$(use_enable gtk xdg-utils) \
		$(use_enable nls) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable static-libs static) \
		$(use_with accessibility audio) \
		$(use_with odbc) \
		$(use_with readline) \
		$(use_with R libR) \
		${myconf} \
		LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_compile() {
	emake
	if use emacs; then
		cd utils/emacs && emake
		elisp-compile gretl.el
	fi
}

src_install() {
	# to fix
	emake -j1 DESTDIR="${D}" install
	if use emacs; then
		elisp-install ${PN} utils/emacs/gretl.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	dodoc README README.audio ChangeLog CompatLog
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "To begin using gretl-mode for all \".inp\" files that you edit,"
		elog "add the following line to your \"~/.emacs\" file:"
		elog "  (add-to-list 'auto-mode-alist '(\"\\\\.inp\\\\'\" . gretl-mode))"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
