# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_EINSTALL=true

inherit eutils elisp-common toolchain-funcs

DESCRIPTION="Regression, econometrics and time-series library"
HOMEPAGE="http://gretl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0/10"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="accessibility cpu_flags_x86_avx +curl emacs gnome gtk mpi nls odbc openmp python
	readline cpu_flags_x86_sse2 R static-libs"

CDEPEND="
	dev-libs/glib:2=
	dev-libs/gmp:0=
	dev-libs/libxml2:2=
	dev-libs/mpfr:0=
	sci-libs/fftw:3.0=
	sci-visualization/gnuplot
	virtual/lapack
	virtual/latex-base
	accessibility? ( app-accessibility/flite:= )
	curl? ( net-misc/curl:0= )
	emacs? ( >=app-editors/emacs-23.1:* )
	gtk? (
			media-libs/gd:2=[png]
			sci-visualization/gnuplot[gd]
			x11-libs/gtk+:3=
			x11-libs/gtksourceview:3.0= )
	mpi? ( virtual/mpi )
	odbc? ( dev-db/unixODBC:0= )
	R? ( dev-lang/R:0= )
	readline? ( sys-libs/readline:0= )"
RDEPEND="${CDEPEND}
	python? ( dev-python/numpy )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

SITEFILE=50${PN}-gentoo.el

REQUIRED_USE="emacs? ( gtk ) !curl? ( !gtk )"

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp ; then
		ewarn "You are using a non capable gcc compiler ( < 4.2 ? )"
		die "Need an OpenMP capable compiler"
	fi
}

src_configure() {
	econf \
		--disable-rpath \
		--enable-shared \
		--with-mpfr \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable curl www) \
		$(use_enable gtk gui) \
		$(use_enable gtk xdg) \
		$(use_enable gtk xdg-utils) \
		$(use_enable nls) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable static-libs static) \
		$(use_with accessibility audio) \
		$(use_with mpi) \
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
		elog "To use gretl-mode for all \".inp\" files that you edit,"
		elog "add the following line to your \"~/.emacs\" file:"
		elog "  (add-to-list 'auto-mode-alist '(\"\\\\.inp\\\\'\" . gretl-mode))"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
