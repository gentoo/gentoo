# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils elisp-common flag-o-matic autotools

DESCRIPTION="Graphics Layout Engine"
HOMEPAGE="http://glx.sourceforge.net/"
MY_P=${PN}-graphics-${PV}
MAN_V=4.2.2
SRC_URI="mirror://sourceforge/glx/${MY_P}f-src.tar.gz"
SLOT="0"
LICENSE="BSD-2 emacs? ( GPL-2 )"
IUSE="X jpeg png tiff doc emacs vim-syntax"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	sys-libs/ncurses:0=
	X? ( x11-libs/libX11 )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	doc? ( dev-texlive/texlive-latexextra )
	emacs? ( >=app-editors/emacs-23.1:* )"

RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	virtual/latex-base
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-parallel.patch
	"${FILESDIR}"/${P}-c++14.patch
	"${FILESDIR}"/${P}-jpeg-9c.patch
)

src_prepare() {
	default
	eaclocal
	eautoconf
}

src_configure() {
	# CPPFLAGS are understood as C++ flags
	append-cppflags ${CXXFLAGS}
	econf \
		--without-rpath \
		--without-qt \
		--with-manip \
		$(use_with X x) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff)
}

src_compile() {
	emake
	if use doc; then
		emake -j1 doc
	fi
	if use emacs; then
		cd contrib/editors/highlighting
		mv ${PN}-emacs.el ${PN}-mode.el
		elisp-compile ${PN}-mode.el || die
	fi
}

src_install() {
	# -jN failed to install some data files
	emake -j1 DESTDIR="${D}" install
	rm -rf "${ED}"/usr/share/doc/gle-graphics
	dodoc README.txt

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins build/doc/gle-manual.pdf
	fi

	if use emacs; then
		elisp-install ${PN} contrib/editors/highlighting/gle-mode.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/64gle-gentoo.el || die
	fi

	if use vim-syntax ; then
		dodir /usr/share/vim/vimfiles/{ftplugins,indent,syntax}
		cd contrib/editors/highlighting/vim || die
		chmod 644 ftplugin/* indent/* syntax/*
		insinto /usr/share/vim/vimfiles
		doins -r ftplugin indent syntax
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
