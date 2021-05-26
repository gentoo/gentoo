# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common flag-o-matic

MY_P=${PN}-graphics-${PV}

DESCRIPTION="Graphics Layout Engine"
HOMEPAGE="http://glx.sourceforge.net/"
SRC_URI="mirror://sourceforge/glx/${MY_P}f-src.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2 emacs? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs jpeg png tiff vim-syntax X"

DEPEND="
	sys-libs/ncurses:=
	emacs? ( >=app-editors/emacs-23.1:* )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	virtual/latex-base
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)"
BDEPEND="doc? ( dev-texlive/texlive-latexextra )"

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
	append-cppflags -std=c++14
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
	use doc && emake -j1 doc

	if use emacs; then
		cd contrib/editors/highlighting || die
		mv ${PN}-emacs.el ${PN}-mode.el || die
		elisp-compile ${PN}-mode.el
	fi
}

src_install() {
	# -jN failed to install some data files
	emake -j1 DESTDIR="${D}" install
	rm -rf "${ED}"/usr/share/doc/gle-graphics || die
	dodoc README.txt

	use doc && dodoc build/doc/gle-manual.pdf

	if use emacs; then
		elisp-install ${PN} contrib/editors/highlighting/gle-mode.{el,elc}
		elisp-site-file-install "${FILESDIR}"/64gle-gentoo.el
	fi

	if use vim-syntax ; then
		dodir /usr/share/vim/vimfiles/{ftplugins,indent,syntax}
		cd contrib/editors/highlighting/vim || die
		chmod 644 ftplugin/* indent/* syntax/* || die
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
