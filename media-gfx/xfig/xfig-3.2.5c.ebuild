# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xfig/xfig-3.2.5c.ebuild,v 1.9 2014/12/01 09:14:02 ago Exp $

EAPI=5

inherit eutils multilib

MY_P=${PN}.${PV}

DESCRIPTION="A menu-driven tool to draw and manipulate objects interactively in an X window"
HOMEPAGE="http://www.xfig.org"
SRC_URI="mirror://sourceforge/mcj/${MY_P}.full.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="x11-libs/libXaw
		x11-libs/libXp
		x11-libs/libXaw3d
		nls? ( x11-libs/libXaw3d[unicode] )
		x11-libs/libXi
		x11-libs/libXt
		virtual/jpeg
		media-libs/libpng
		media-fonts/font-misc-misc
		media-fonts/urw-fonts
		>=media-gfx/transfig-3.2.5-r1
		media-libs/netpbm"
DEPEND="${RDEPEND}
		x11-misc/imake
		x11-proto/xproto
		x11-proto/inputproto"

S=${WORKDIR}/${MY_P}

sed_Imakefile() {
	# see Imakefile for details
	vars2subs=( BINDIR="${EPREFIX}"/usr/bin
		PNGINC=-I"${EPREFIX}"/usr/include
		JPEGLIBDIR="${EPREFIX}"/usr/$(get_libdir)
		JPEGINC=-I"${EPREFIX}"/usr/include
		XPMLIBDIR="${EPREFIX}"/usr/$(get_libdir)
		XPMINC=-I"${EPREFIX}"/usr/include/X11
		USEINLINE=-DUSE_INLINE
		XFIGLIBDIR="${EPREFIX}"/usr/share/xfig
		XFIGDOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		MANDIR="${EPREFIX}/usr/share/man/man\$\(MANSUFFIX\)"
		"CC=$(tc-getCC)" )

	for variable in "${vars2subs[@]}" ; do
		varname=${variable%%=*}
		varval=${variable##*=}
		sed -i \
			-e "s:^\(XCOMM\)*[[:space:]]*${varname}[[:space:]]*=.*$:${varname} = ${varval}:" \
			"$@" || die
	done
	if use nls; then
		# XAW_INTERNATIONALIZATION fixes #405475 (comment 17) and #426780 by Markus Peloquin
		sed -i \
			-e "s:^\(XCOMM\)*[[:space:]]*\(#define I18N\).*$:\2:" \
			-e "s:^\(XCOMM\)*[[:space:]]*\(XAW_INTERN = -DXAW_INTERNATIONALIZATION\).*$:\2:" \
			"$@" || die
	fi
	sed -i -e "s:^\(XCOMM\)*[[:space:]]*\(#define XAW3D1_5E\).*$:\2:" "$@" || die
}

src_prepare() {
	# Permissions are really crazy here
	chmod -R go+rX . || die
	find . -type f -exec chmod a-x '{}' \; || die
	epatch "${FILESDIR}/${PN}-3.2.5c-spelling.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-papersize_b1.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-pdfimport_mediabox.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-network_images.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-app-defaults.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-urwfonts.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-mkstemp.patch" #264575
	epatch "${FILESDIR}/${PN}-3.2.5c-darwin.patch"
	epatch "${FILESDIR}/${PN}-3.2.5b-solaris.patch"
	epatch "${FILESDIR}/${PN}-3.2.5c-XAW3D1_5E_notlocal.patch"
	epatch "${FILESDIR}/${PN}-3.2.5c-crash-on-exit.patch"

	sed_Imakefile Imakefile
	sed -e "s:/usr/lib/X11/xfig:${EPREFIX}/usr/share/doc/${PF}:" \
		-i Doc/xfig.man || die
}

src_compile() {
	local EXTCFLAGS=${CFLAGS}
	xmkmf || die
	[[ ${CHOST} == *-solaris* ]] && EXTCFLAGS="${EXTCFLAGS} -D_POSIX_SOURCE"
	emake CC="$(tc-getCC)" LOCAL_LDFLAGS="${LDFLAGS}" CDEBUGFLAGS="${EXTCFLAGS}" \
		USRLIBDIR="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	emake -j1 DESTDIR="${D}" install install.libs install.man

	dodoc README FIGAPPS CHANGES LATEX.AND.XFIG

	doicon xfig.png
	make_desktop_entry xfig Xfig xfig
}

pkg_postinst() {
	einfo "Don't forget to update xserver's font path for media-fonts/urw-fonts."
}
