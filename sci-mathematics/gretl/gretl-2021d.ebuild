# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common toolchain-funcs xdg-utils

DESCRIPTION="Regression, econometrics and time-series library"
HOMEPAGE="http://gretl.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0/40"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_avx emacs extras gnome gtk mpi nls odbc openmp python
	readline cpu_flags_x86_sse2 R"

DEPEND="
	dev-libs/glib:2=
	>=dev-libs/gmp-4.0.1:0=
	dev-libs/json-glib:0=
	dev-libs/libxml2:2=
	>=dev-libs/mpfr-2.2.0:0=
	net-misc/curl:0=
	sci-libs/fftw:3.0=
	sci-visualization/gnuplot
	virtual/lapack
	virtual/latex-base
	emacs? ( >=app-editors/emacs-23.1:* )
	gnome? ( >=gnome-extra/libgsf-1.14.47[gtk?] )
	gtk? (
			media-libs/gd:2=[png]
			>=sci-visualization/gnuplot-5.0[cairo]
			x11-libs/gtk+:3=
			x11-libs/gtksourceview:3.0= )
	mpi? ( virtual/mpi )
	odbc? ( dev-db/unixODBC:0= )
	R? ( dev-lang/R:0= )
	readline? ( sys-libs/readline:0= )"
RDEPEND="${DEPEND}
	python? ( dev-python/numpy )"
BDEPEND="virtual/pkgconfig
	extras? ( dev-texlive/texlive-latexextra )
	gtk? ( x11-misc/xdg-utils )"

SITEFILE=50${PN}-gentoo.el

REQUIRED_USE="emacs? ( gtk )"

PATCHES=(
	"${FILESDIR}"/${PN}-2001d-appdatadir.patch
)

DOCS=( README ChangeLog CompatLog )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	xdg_environment_reset
	econf \
		--disable-rpath \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable extras build-addons) \
		$(use_enable gtk gui) \
		$(use_enable gtk xdg) \
		$(use_enable gtk xdg-utils) \
		$(use_enable nls) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_with gnome gsf) \
		$(use_with mpi) \
		$(use_with odbc) \
		$(use_with readline) \
		$(use_with R libR) \
		${myconf} \
		LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_compile() {
	default
	if use emacs; then
		cd utils/emacs && emake
		elisp-compile gretl.el
	fi
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
	if use emacs; then
		elisp-install ${PN} utils/emacs/gretl.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "To use gretl-mode for all \".inp\" files that you edit,"
		elog "add the following line to your \"~/.emacs\" file:"
		elog "  (add-to-list 'auto-mode-alist '(\"\\\\.inp\\\\'\" . gretl-mode))"
	fi

	if use gtk; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	if use gtk; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
	fi
}
