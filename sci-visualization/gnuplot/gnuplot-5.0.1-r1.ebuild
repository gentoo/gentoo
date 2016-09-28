# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic multilib readme.gentoo toolchain-funcs wxwidgets

DESCRIPTION="Command-line driven interactive plotting program"
HOMEPAGE="http://www.gnuplot.info/"

if [[ -z ${PV%%*9999} ]]; then
	inherit autotools cvs
	ECVS_SERVER="gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot"
	ECVS_MODULE="gnuplot"
	ECVS_BRANCH="branch-5-0-stable"
	ECVS_USER="anonymous"
	ECVS_CVS_OPTIONS="-dP"
	MY_P="${PN}"
	SRC_URI=""
	KEYWORDS="alpha arm hppa ppc64"
else
	MY_P="${P/_/.}"
	SRC_URI="mirror://sourceforge/gnuplot/${MY_P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ~ia64 ~ppc ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
	inherit autotools
fi

LICENSE="gnuplot bitmap? ( free-noncomm )"
SLOT="0"
IUSE="aqua bitmap cairo compat doc examples +gd ggi latex libcaca libcerf lua qt4 readline svga wxwidgets X"

RDEPEND="
	cairo? (
		x11-libs/cairo
		x11-libs/pango )
	gd? ( >=media-libs/gd-2.0.35-r3:2=[png] )
	ggi? ( media-libs/libggi )
	latex? (
		virtual/latex-base
		lua? (
			dev-tex/pgf
			>=dev-texlive/texlive-latexrecommended-2008-r2 ) )
	libcaca? ( media-libs/libcaca )
	lua? ( dev-lang/lua:0 )
	qt4? ( >=dev-qt/qtcore-4.5:4
		>=dev-qt/qtgui-4.5:4
		>=dev-qt/qtsvg-4.5:4 )
	readline? ( sys-libs/readline:0 )
	libcerf? ( sci-libs/libcerf )
	svga? ( media-libs/svgalib )
	wxwidgets? (
		x11-libs/wxGTK:3.0[X]
		x11-libs/cairo
		x11-libs/pango
		x11-libs/gtk+:2 )
	X? ( x11-libs/libXaw )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		app-text/ghostscript-gpl )"

S="${WORKDIR}/${MY_P}"

GP_VERSION="${PV%.*}"
E_SITEFILE="lisp/50${PN}-gentoo.el"
TEXMF="${EPREFIX}/usr/share/texmf-site"

src_prepare() {
	# Fix underlinking
	epatch "${FILESDIR}"/${P}-fix-underlinking.patch

	if [[ -z ${PV%%*9999} ]]; then
		local dir
		for dir in config demo m4 term tutorial; do
			emake -C "$dir" -f Makefile.am.in Makefile.am
		done
		#eautoreconf
	fi

	# Add special version identification as required by provision 2
	# of the gnuplot license
	sed -i -e "1s/.*/& (Gentoo revision ${PR})/" PATCHLEVEL || die

	# hacky workaround
	# Please hack the buildsystem if you like
	if use prefix && use qt4; then
		append-ldflags -Wl,-rpath,"${EPREFIX}"/usr/$(get_libdir)/qt4
	fi

	DOC_CONTENTS='Gnuplot no longer links against pdflib, see the ChangeLog
		for details. You can use the "pdfcairo" terminal for PDF output.'
	use cairo || DOC_CONTENTS+=' It is available with USE="cairo".'
	use svga && DOC_CONTENTS+='\n\nIn order to enable ordinary users to use
		SVGA console graphics, gnuplot needs to be set up as setuid root.
		Please note that this is usually considered to be a security hazard.
		As root, manually "chmod u+s /usr/bin/gnuplot".'
	use gd && DOC_CONTENTS+='\n\nFor font support in png/jpeg/gif output,
		you may have to set the GDFONTPATH and GNUPLOT_DEFAULT_GDFONT
		environment variables. See the FAQ file in /usr/share/doc/${PF}/
		for more information.'

	mv configure.in configure.ac || die
	eautoreconf

	# Make sure we don't mix build & host flags.
	sed -i \
		-e 's:@CPPFLAGS@:$(BUILD_CPPFLAGS):' \
		-e 's:@CFLAGS@:$(BUILD_CFLAGS):' \
		-e 's:@LDFLAGS@:$(BUILD_LDFLAGS):' \
		-e 's:@CC@:$(CC_FOR_BUILD):' \
		docs/Makefile.in || die
}

src_configure() {
	if ! use latex; then
		sed -i -e '/SUBDIRS/s/LaTeX//' share/Makefile.in || die
	fi

	if use wxwidgets; then
		WX_GTK_VER="3.0"
		need-wxwidgets unicode
	fi

	tc-export CC CXX			#453174
	tc-export_build_env BUILD_CC
	export CC_FOR_BUILD=${BUILD_CC}

	econf \
		--without-pdf \
		--with-texdir="${TEXMF}/tex/latex/${PN}" \
		--with-readline=$(usex readline gnu builtin) \
		$(use_with bitmap bitmap-terminals) \
		$(use_with cairo) \
		$(use_enable compat backwards-compatibility) \
		$(use_with doc tutorial) \
		$(use_with gd) \
		"$(use_with ggi ggi "${EPREFIX}/usr/$(get_libdir)")" \
		"$(use_with ggi xmi "${EPREFIX}/usr/$(get_libdir)")" \
		"$(use_with libcaca caca "${EPREFIX}/usr/$(get_libdir)")" \
		$(use_with libcerf) \
		$(use_with lua) \
		$(use_with svga linux-vga) \
		$(use_with X x) \
		--enable-stats \
		$(use_with qt4 qt qt4) \
		$(use_enable wxwidgets) \
		DIST_CONTACT="https://bugs.gentoo.org/" \
		EMACS=no
}

src_compile() {
	# Prevent access violations, see bug 201871
	export VARTEXFONTS="${T}/fonts"

	# We believe that the following line is no longer needed.
	# In case of problems file a bug report at bugs.gentoo.org.
	#addwrite /dev/svga:/dev/mouse:/dev/tts/0

	emake all

	if use doc; then
		# Avoid sandbox violation in epstopdf/ghostscript
		addpredict /var/cache/fontconfig
		emake -C docs gnuplot.pdf
		emake -C tutorial pdf
	fi
}

src_install () {
	emake DESTDIR="${D}" install

	dodoc BUGS ChangeLog NEWS PGPKEYS PORTING README*
	newdoc term/PostScript/README README-ps
	newdoc term/js/README README-js
	use lua && newdoc term/lua/README README-lua
	readme.gentoo_create_doc

	if use examples; then
		# Demo files
		insinto /usr/share/${PN}/${GP_VERSION}
		doins -r demo
		rm -f "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/Makefile*
		rm -f "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/binary*
	fi

	if use doc; then
		# Manual, tutorial, FAQ
		dodoc docs/gnuplot.pdf tutorial/{tutorial.dvi,tutorial.pdf} FAQ.pdf
		# Documentation for making PostScript files
		docinto psdoc
		dodoc docs/psdoc/{*.doc,*.tex,*.ps,*.gpi,README}
	fi
}

src_test() {
	GNUTERM="unknown" default_src_test
}

pkg_postinst() {
	use latex && texmf-update
	readme.gentoo_print_elog
}

pkg_postrm() {
	use latex && texmf-update
}
