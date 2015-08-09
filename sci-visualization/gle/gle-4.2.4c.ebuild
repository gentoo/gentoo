# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils elisp-common qt4-r2 flag-o-matic autotools

DESCRIPTION="Graphics Layout Engine"
HOMEPAGE="http://glx.sourceforge.net/"
MY_P=${PN}-graphics-${PV}
MAN_V=4.2.2
SRC_URI="mirror://sourceforge/glx/${MY_P}f-src.tar.gz
	doc? ( mirror://sourceforge/glx/${PN}-manual-${MAN_V}.pdf
		   mirror://sourceforge/glx/GLEusersguide.pdf )"
SLOT="0"
LICENSE="BSD-2 emacs? ( GPL-2 ) qt4? ( GPL-2 )"
IUSE="X qt4 jpeg png tiff doc emacs vim-syntax"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	sys-libs/ncurses
	X? ( x11-libs/libX11 )
	qt4? ( dev-qt/qtopengl:4 )
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	emacs? ( virtual/emacs )"

RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	virtual/latex-base
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.2.4b-parallel.patch
	eaclocal
	eautoconf
}

src_configure() {
	# CPPFLAGS are understood as C++ flags
	append-cppflags ${CXXFLAGS}
	econf \
		--without-rpath \
		--with-manip \
		$(use_with qt4 qt "${EPREFIX}"/usr) \
		$(use_with X x) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff)
}

src_compile() {
	emake
	if use emacs; then
		cd contrib/editors/highlighting
		mv ${PN}-emacs.el ${PN}-mode.el
		elisp-compile ${PN}-mode.el || die
	fi
}

src_install() {
	# -jN failed to install some data files
	emake -j1 DESTDIR="${D}" install
	rmdir "${ED}"/usr/share/doc/gle-graphics || die "rmdir gle-graphics failed"
	dodoc README.txt

	if use qt4; then
		newicon src/gui/images/gle_icon.png gle.png
		make_desktop_entry qgle GLE gle
		newdoc src/gui/readme.txt gui_readme.txt
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${PN}-manual-${MAN_V}.pdf \
			"${DISTDIR}"/GLEusersguide.pdf
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
