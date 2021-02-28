# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit autotools elisp-common latex-package python-r1

DESCRIPTION="A vector graphics language that provides a framework for technical drawing"
HOMEPAGE="https://asymptote.sourceforge.io/"
SRC_URI="mirror://sourceforge/asymptote/${P}.src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+boehm-gc curl doc emacs examples fftw gsl +imagemagick latex offscreen +opengl python sigsegv svg test vim-syntax"
# FIXME: xasy is currently broken
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	offscreen? ( opengl )
	doc? ( boehm-gc )"

RDEPEND="
	>=sys-libs/ncurses-5.4-r5:0=
	>=sys-libs/readline-4.3-r5:0=
	net-libs/libtirpc
	imagemagick? ( media-gfx/imagemagick[png] )
	opengl? ( media-libs/mesa media-libs/freeglut media-libs/glew:0 media-libs/glm )
	offscreen? ( media-libs/mesa[osmesa] )
	svg? ( app-text/dvisvgm )
	sigsegv? ( dev-libs/libsigsegv )
	boehm-gc? ( >=dev-libs/boehm-gc-7.0[cxx,threads] )
	fftw? ( >=sci-libs/fftw-3.0.1 )
	gsl? ( sci-libs/gsl )
	python? ( ${PYTHON_DEPS} )
	curl? ( net-misc/curl )
	latex? (
		virtual/latex-base
		>=dev-texlive/texlive-latexextra-2013
		)
	emacs? ( >=app-editors/emacs-23.1:* )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"
DEPEND="${RDEPEND}
	doc? (
		dev-lang/perl
		media-gfx/imagemagick[png]
		virtual/texi2dvi
		virtual/latex-base
		app-text/ghostscript-gpl )
	test? ( app-text/ghostscript-gpl )"

TEXMF=/usr/share/texmf-site

PATCHES=(
	# Changing pdf, ps, image viewers to xdg-open
	"${FILESDIR}/${P}-xdg-utils.patch"

	# Bug #322473
	"${FILESDIR}/${P}-info.patch"
)

src_prepare() {
	sed -e "s:Datadir/doc/asymptote:Datadir/doc/${PF}:" \
		-i configure.ac \
		|| die "sed configure.ac failed"

	default
	eautoreconf
}

src_configure() {
	# for the CPPFLAGS see
	# https://sourceforge.net/forum/forum.php?thread_id=1683277&forum_id=409349
	econf \
		CPPFLAGS=-DHAVE_SYS_TYPES_H \
		CFLAGS="${CXXFLAGS}" \
		--disable-gc-debug \
		$(use_enable boehm-gc gc system) \
		$(use_enable curl) \
		$(use_enable fftw) \
		$(use_enable gsl) \
		$(use_enable opengl gl) \
		$(use_enable offscreen) \
		$(use_enable sigsegv)
}

src_compile() {
	default

	cd doc || die
	emake asy.1
	if use doc; then
		# info
		einfo "Making info"
		emake ${PN}.info
		cd FAQ || die
		emake
		cd .. || die
		# pdf
		einfo "Making pdf docs"
		export VARTEXFONTS="${T}"/fonts
		# see bug #260606
		emake -j1 asymptote.pdf
		emake CAD.pdf
	fi
	cd .. || die

	if use emacs; then
		einfo "Compiling emacs lisp files"
		elisp-compile base/*.el
	fi
}

src_install() {
	# the program
	dobin asy

	# .asy files
	insinto /usr/share/${PN}
	doins -r base/*.asy base/shaders base/webgl

	# documentation
	dodoc BUGS ChangeLog README ReleaseNotes TODO
	doman doc/asy.1

	# examples
	if use examples; then
		insinto /usr/share/${PN}/examples
		doins \
			examples/*.asy \
			examples/*.views \
			examples/*.dat \
			examples/*.bib \
			examples/piicon.png \
			examples/100d.pdb1 \
			doc/*.asy \
			doc/*.csv \
			doc/*.dat \
			doc/pixel.pdf \
			doc/extra/*.asy
		insinto /usr/share/${PN}/examples/animations
		doins examples/animations/*.asy
	fi

	# LaTeX style
	if use latex; then
		cd doc || die
		insinto "${TEXMF}"/tex/latex/${PN}
		doins ${PN}.sty asycolors.sty
		if use examples; then
			insinto /usr/share/${PN}/examples
			doins latexusage.tex externalprc.tex
			insinto /usr/share/${PN}/examples/animations
			doins ../examples/animations/*.tex
		fi
		cd .. || die
	fi

	# asymptote.py
	if use python; then
		python_foreach_impl python_domodule base/${PN}.py
	fi

	# emacs mode
	if use emacs; then
		elisp-install ${PN} base/*.el base/*.elc asy-keywords.el
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
	fi

	# vim syntax
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins base/asy.vim
		insinto /usr/share/vim/vimfiles/ftdetect
		doins base/asy_filetype.vim
	fi

	# extra documentation
	if use doc; then
		cd doc || die
		doinfo ${PN}.info*
		dodoc ${PN}.pdf CAD.pdf
		cd FAQ || die
		dodoc asy-faq.ascii
		doinfo asy-faq.info
		docinto html/FAQ
		dodoc asy-faq.html/*
	fi
}

pkg_postinst() {
	use latex && latex-package_rehash
	use emacs && elisp-site-regen

	elog 'Use the variable ASYMPTOTE_PSVIEWER to set the postscript viewer'
	elog 'Use the variable ASYMPTOTE_PDFVIEWER to set the PDF viewer'
}

pkg_postrm() {
	use latex && latex-package_rehash
	use emacs && elisp-site-regen
}
