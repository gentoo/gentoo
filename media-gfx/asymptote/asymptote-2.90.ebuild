# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools elisp-common latex-package python-r1

DESCRIPTION="A vector graphics language that provides a framework for technical drawing"
HOMEPAGE="https://asymptote.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/asymptote/${P}.src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+boehm-gc context curl doc emacs examples fftw gsl +imagemagick latex lsp offscreen +opengl python sigsegv svg test vim-syntax X"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	offscreen? ( opengl )
	doc? ( boehm-gc )"

RDEPEND="
	>=sys-libs/ncurses-5.4-r5:0=
	>=sys-libs/readline-4.3-r5:0=
	net-libs/libtirpc:=
	imagemagick? ( media-gfx/imagemagick[png] )
	opengl? ( media-libs/mesa[X(+)] media-libs/freeglut media-libs/glew:0 media-libs/glm )
	offscreen? ( media-libs/mesa[osmesa] )
	svg? ( app-text/dvisvgm )
	sigsegv? ( dev-libs/libsigsegv )
	boehm-gc? ( >=dev-libs/boehm-gc-7.0[cxx,threads] )
	fftw? ( >=sci-libs/fftw-3.0.1:= )
	gsl? ( sci-libs/gsl:= )
	python? ( ${PYTHON_DEPS} )
	curl? ( net-misc/curl )
	lsp? (
		dev-libs/boost
		dev-libs/rapidjson
		dev-libs/utfcpp
	)
	X? (
		${PYTHON_DEPS}
		dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets,svg]
		dev-python/cson
		dev-python/numpy
		>=gnome-base/librsvg-2.40
	)
	latex? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)
	context? ( dev-texlive/texlive-context )
	emacs? ( >=app-editors/emacs-23.1:* )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"
DEPEND="${RDEPEND}
	dev-lang/perl
	doc? (
		media-gfx/imagemagick[png]
		virtual/texi2dvi
		virtual/latex-base
		dev-texlive/texlive-latexextra
		app-text/ghostscript-gpl )
	test? ( app-text/ghostscript-gpl )"

TEXMF=/usr/share/texmf-site

PATCHES=(
	# Changing pdf, ps, image viewers to xdg-open
	"${FILESDIR}/${PN}-2.85-xdg-utils.patch"

	# Bug #322473
	"${FILESDIR}/${PN}-2.70-info.patch"
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
		--disable-gc-full-debug \
		--with-latex=/usr/share/texmf-site/tex/latex \
		--with-context=/usr/share/texmf-site/tex/context \
		$(use_enable boehm-gc gc system) \
		$(use_enable curl) \
		$(use_enable lsp) \
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
	einfo "Making info"
	cd png || die
	emake ${PN}.info
	cd .. || die
	if use doc; then
		cd FAQ || die
		emake
		cd .. || die
		# pdf
		einfo "Making pdf docs"
		export VARTEXFONTS="${T}"/fonts
		# see bug #260606
		emake -j1 asymptote.pdf
		emake CAD.pdf asy-latex.pdf asyRefCard.pdf
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
	doins -r base/*.asy base/*.js base/*.sh base/*.ps base/shaders base/webgl
	chmod 755 "${D}"/usr/share/${PN}/shaders/*

	# documentation
	dodoc README ReleaseNotes ChangeLog
	cd doc || die
	doman asy.1
	doinfo png/${PN}.info
	if use doc; then
		dodoc FAQ/asy-faq.ascii
		dodoc CAD.pdf asy-latex.pdf asyRefCard.pdf asymptote.pdf
	fi
	cd .. || die

	# asymptote.py
	if use python; then
		python_moduleinto ${PN}
		python_foreach_impl python_domodule aspy.py
		python_foreach_impl python_domodule base/${PN}.py
	fi

	# X GUI
	if use X; then
		cd GUI || die
		python_setup
		sed -e 1d -i xasy.py
		echo "#!/usr/bin/env ${EPYTHON}" > xasy1
		cat xasy1 xasy.py > xasy
		rm xasy1 xasy.py
		mv xasy xasy.py
		cd .. || die
		python_domodule GUI
		chmod 755 "${D}/$(python_get_sitedir)/${PN}/GUI/xasy.py"
		dosym "$(python_get_sitedir)/${PN}/GUI/xasy.py" /usr/bin/xasy
		doman doc/xasy.1x
	fi

	# examples
	if use examples; then
		docinto examples
		dodoc \
			examples/*.asy \
			examples/*.views \
			examples/*.dat \
			examples/*.bib \
			examples/*.png \
			examples/*.pdb1 \
			doc/*.asy \
			doc/*.csv \
			doc/*.dat \
			doc/pixel.pdf \
			doc/extra/*.asy
		docinto examples/animations
		dodoc examples/animations/*.asy
	fi

	# LaTeX style
	if use latex; then
		cd doc || die
		insinto "${TEXMF}"/tex/latex/${PN}
		doins *.sty latexmkrc
		if use examples; then
			docinto examples
			dodoc latexusage.tex externalprc.tex
			docinto examples/animations
			dodoc ../examples/animations/*.tex
		fi
		cd .. || die
	fi

	# ConTeXt
	if use context; then
		insinto /usr/share/texmf-site/tex/context
		doins doc/colo-asy.tex
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
