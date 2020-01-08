# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools elisp-common latex-package multilib python-r1

DESCRIPTION="A vector graphics language that provides a framework for technical drawing"
HOMEPAGE="http://asymptote.sourceforge.net/"
SRC_URI="mirror://sourceforge/asymptote/${P}.src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+boehm-gc doc emacs examples fftw gsl +imagemagick latex offscreen +opengl python sigsegv svg test vim-syntax X"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	offscreen? ( opengl )
	doc? ( boehm-gc )"

RDEPEND="
	>=sys-libs/ncurses-5.4-r5:0=
	>=sys-libs/readline-4.3-r5:0=
	imagemagick? ( media-gfx/imagemagick[png] )
	opengl? ( media-libs/mesa[X(+)] media-libs/freeglut media-libs/glew:0 media-libs/glm )
	offscreen? ( media-libs/mesa[osmesa] )
	svg? ( app-text/dvisvgm )
	sigsegv? ( dev-libs/libsigsegv )
	boehm-gc? ( >=dev-libs/boehm-gc-7.0[cxx,threads] )
	fftw? ( >=sci-libs/fftw-3.0.1 )
	gsl? ( sci-libs/gsl )
	python? ( ${PYTHON_DEPS} )
	X? (
		${PYTHON_DEPS}
		dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets,svg]
		dev-python/numpy
		dev-python/pycson
		>=gnome-base/librsvg-2.40
		)
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
	doins base/*.asy

	# documentation
	dodoc BUGS ChangeLog README ReleaseNotes TODO
	doman doc/asy.1

	# X GUI
	if use X; then
		insinto /usr/share/${PN}
		doins -r GUI
		chmod +x "${D}"usr/share/${PN}/GUI/xasy.py
		dosym ../share/${PN}/GUI/xasy.py /usr/bin/xasy
		doman doc/xasy.1x
	fi

	# examples
	if use examples; then
		insinto /usr/share/${PN}/examples
		doins \
			examples/*.asy \
			examples/*.eps \
			doc/*.asy \
			doc/*.csv \
			doc/*.dat \
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
			doins latexusage.tex
		fi
		cd .. || die
	fi

	# asymptote.py
	if use python; then
		python_foreach_impl python_domodule base/${PN}.py
	fi

	# emacs mode
	if use emacs; then
		elisp-install ${PN} base/*.el base/*.elc
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
	fi

	# vim syntax
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins base/asy.vim
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/asy-ftd.vim
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
