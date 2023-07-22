# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit autotools elisp-common flag-o-matic python-single-r1 xdg-utils

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

IUSE="clisp clozurecl clozurecl64 cmucl ecls emacs gcl gui nls +sbcl vtk X test"
RESTRICT="test" # bug 838202

# Languages
LANGS="de es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} l10n_${lang/_/-}"
done

LISP_DEPEND="
	clisp? ( dev-lisp/clisp:= )
	clozurecl? ( dev-lisp/clozurecl app-misc/rlwrap )
	clozurecl64? ( dev-lisp/clozurecl app-misc/rlwrap )
	cmucl? ( dev-lisp/cmucl app-misc/rlwrap )
	ecls? ( dev-lisp/ecls:= app-misc/rlwrap )
	gcl? ( >=dev-lisp/gcl-2.6.14[ansi,readline] )
	sbcl? ( dev-lisp/sbcl:= app-misc/rlwrap )
"

# LISP_DEPEND is included in both BDEPEND and DEPEND because the various
# lisp engines are used to both compile and run maxima. It's possible
# that they don't (all?) need to be listed in DEPEND; who knows.
BDEPEND="
	${LISP_DEPEND}
	test? ( sci-visualization/gnuplot )
	sys-apps/texinfo
"

DEPEND="
	${LISP_DEPEND}
	virtual/libcrypt:=
	emacs? ( >=app-editors/emacs-26:* )
	gui? ( dev-lang/tk:0 )
"

# texlive-latexrecommended needed by imaxima for breqn.sty
#
# VTK is an optional plotting backend that can be enabled by
# running "draw_renderer: 'vtk;" within maxima.
#
# It's NON-optional for the scene() command, but that command is
# currently useless since Tcl/Tk support was dropped in sci-libs/vtk.
# Thus we include VTK only as an optional dependency.
#
# We require app-misc/rlwrap for any lisps that don't support readline
# themselves.
RDEPEND="
	${DEPEND}
	X? (
		x11-misc/xdg-utils
		sci-visualization/gnuplot[gd]
		vtk? (
			${PYTHON_DEPS}
			sci-libs/vtk[python,rendering,${PYTHON_SINGLE_USEDEP}]
		)
	)
	emacs? (
		virtual/latex-base
		app-emacs/auctex
		app-text/ghostscript-gpl
		dev-texlive/texlive-latexrecommended
	)"

# Maxima can make use of X features like plotting (and launching a PNG
# viewer) from the console, but you can't use the xmaxima GUI without X.
REQUIRED_USE="
	vtk? ( ${PYTHON_REQUIRED_USE} )
	|| ( clisp clozurecl clozurecl64 cmucl ecls gcl sbcl )
	gui? ( X )"

TEXMF="${EPREFIX}"/usr/share/texmf-site

pkg_setup() {
	# Set the PYTHON variable to whatever it should be.
	use vtk && python-single-r1_pkg_setup
}

PATCHES=(
	"${FILESDIR}/imaxima-0.patch"
	"${FILESDIR}/xdg-utils-1.patch"
	"${FILESDIR}/wish-2.patch"
	"${FILESDIR}/rmaxima-0.patch"
	"${FILESDIR}/emacs-0.patch"
	"${FILESDIR}/clisp-1.patch"
	"${FILESDIR}/clozurecl-3.patch"
	"${FILESDIR}/cmucl-1.patch"
	"${FILESDIR}/sbcl-2.patch"
)

src_prepare() {
	default

	# bug #343331
	rm share/Makefile.in || die
	rm src/Makefile.in || die
	touch src/*.mk
	touch src/Makefile.am

	eautoreconf
}

src_configure() {
	local CONFS=""

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "l10n_${lang/_/-}"; then
				CONFS="${CONFS} --enable-lang-${lang}"
			fi
		done
	fi

	# Using raw-ldflags fixes the error,
	#
	#   x86_64-pc-linux-gnu/bin/ld: fatal error: -O1 -Wl: invalid option
	#   value (expected an integer): 1 -Wl
	#
	# when building the maxima.fas library for ECL. See upstream bugs:
	#
	#   * https://sourceforge.net/p/maxima/bugs/3759/
	#   * https://gitlab.com/embeddable-common-lisp/ecl/-/issues/636
	#
	# The 32-bit and 64-bit version of the clozurecl executable
	# are both called "ccl" on Gentoo, so we need the additional
	# use_with for clozurecl64. See bugs 665364 and 715278....
	#
	# The usex works around https://sourceforge.net/p/maxima/bugs/3757/
	#
	econf ${CONFS} \
		LDFLAGS="$(raw-ldflags)" \
		$(use_enable clisp) \
		$(use_enable clozurecl ccl) \
		$(use_enable clozurecl64 ccl64) \
		$(usex clozurecl64 "--with-ccl64=ccl" "") \
		$(use_enable cmucl) \
		$(use_enable ecls ecl) \
		$(use_enable emacs) \
		$(use_enable gcl) \
		$(use_with gui wish) \
		$(use_enable sbcl) \
		--with-lispdir="${EPREFIX}/${SITELISP}/${PN}"
}

src_compile() {
	emake
	if use emacs; then
		pushd interfaces/emacs/emaxima > /dev/null
		elisp-compile *.el
		popd > /dev/null
		pushd interfaces/emacs/imaxima > /dev/null
		BYTECOMPFLAGS="-L . -L ../emaxima"
		elisp-compile *.el
		popd > /dev/null
	fi
}

src_install() {
	docompress -x /usr/share/info
	emake DESTDIR="${D}" emacsdir="${EPREFIX}/${SITELISP}/${PN}" install

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it from dodoc
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING README README-lisps.md
	dodir /usr/share/doc
	dosym ../${PN}/${PV}/doc /usr/share/doc/${PF}

	if use emacs; then
		elisp-install ${PN} interfaces/emacs/{emaxima,imaxima}/*.{el,elc,lisp}
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo-1.el

		rm "${ED}"/${SITELISP}/${PN}/emaxima.sty || die
		insinto ${TEXMF}/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty

		insinto /usr/share/${PN}/${PV}/doc/imaxima
		doins interfaces/emacs/imaxima/README
		doins -r interfaces/emacs/imaxima/imath-example

		if ! use gcl; then
			# This emacs package is used to run gcl, maxima, gdb, etc.
			# all at once and possibly in the same buffer. As such, it's
			# no use without gcl (more to the point: it requires gcl.el).
			find "${ED}" -name 'dbl.el' -type f -delete || die
		fi
	fi

	if use ecls; then
		# Use ECL to find the path where it expects to load packages from.
		ECLLIB=$(ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)")
		insinto "${ECLLIB#${EPREFIX}}"
		doins src/binary-ecl/maxima.fas
	fi
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}
