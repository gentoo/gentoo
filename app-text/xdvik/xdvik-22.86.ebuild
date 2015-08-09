# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic elisp-common toolchain-funcs multilib

DESCRIPTION="DVI previewer for X Window System"
HOMEPAGE="http://xdvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/xdvi/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
LICENSE="GPL-2"
IUSE="motif neXt Xaw3d emacs"

RDEPEND="media-libs/freetype:2
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXpm
	motif? ( >=x11-libs/motif-2.3:0 )
	!motif? (
		neXt? ( x11-libs/neXtaw )
		!neXt? (
			Xaw3d? ( x11-libs/libXaw3d )
			!Xaw3d? ( x11-libs/libXaw )
		)
	)
	dev-libs/kpathsea"
DEPEND="sys-devel/flex
	virtual/yacc
	${RDEPEND}"
RDEPEND="${RDEPEND}
	virtual/latex-base
	!<app-text/texlive-2007"
S=${WORKDIR}/${P}/texk/xdvik

src_prepare() {
	# Make sure system kpathsea headers are used
	cd "${WORKDIR}/${P}/texk/kpathsea"
	for i in *.h ; do echo "#include_next \"$i\"" > $i; done
}

src_configure() {
	local toolkit

	if use motif ; then
		toolkit="motif"
		use neXt && ewarn "neXt USE flag ignored (superseded by motif)"
		use Xaw3d && ewarn "Xaw3d USE flag ignored (superseded by motif)"
	elif use neXt ; then
		toolkit="neXtaw"
		use Xaw3d && ewarn "Xaw3d USE flag ignored (superseded by neXt)"
	elif use Xaw3d ; then
		toolkit="xaw3d"
	else
		toolkit="xaw"
	fi

	econf \
		--with-system-freetype2 \
		--with-system-kpathsea \
		--with-kpathsea-include="${EPREFIX}"/usr/include/kpathsea \
		--with-xdvi-x-toolkit="${toolkit}" \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir)
}

src_compile() {
	emake kpathsea_dir="${EPREFIX}/usr/include/kpathsea"
	use emacs && elisp-compile xdvi-search.el
}

src_install() {
	dodir /usr/share/texmf-dist/dvips/config

	emake DESTDIR="${D}" install

	dosym /usr/share/texmf-dist/xdvi/XDvi /usr/share/X11/app-defaults/XDvi

	dodoc BUGS FAQ README.*

	use emacs && elisp-install tex-utils *.el *.elc

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry xdvi "XDVI" xdvik "Graphics;Viewer"
	echo "MimeType=application/x-dvi;" >> "${ED}"usr/share/applications/xdvi-"${PN}".desktop
}

pkg_postinst() {
	if use emacs; then
		elog "Add"
		elog "	(add-to-list 'load-path \"${EPREFIX}${SITELISP}/tex-utils\")"
		elog "	(require 'xdvi-search)"
		elog "to your ~/.emacs file"
	fi
}
