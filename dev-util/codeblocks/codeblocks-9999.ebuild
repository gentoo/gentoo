# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit autotools subversion wxwidgets xdg

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
SRC_URI=""
ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"
ESVN_FETCH_CMD="svn checkout --ignore-externals"

IUSE="contrib debug pch"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-arch/zip
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.1-r2:0/3.1
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-text/hunspell
		dev-libs/boost:=
	)"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/codeblocks-17.12-nodebug.diff )

src_prepare() {
	default
	# Let's make the autorevision work.
	subversion_wc_info
	CB_LCD=$(LC_ALL=C svn info "${ESVN_WC_PATH}" | grep "^Last Changed Date:" | cut -d" " -f4,5)
	echo "m4_define([SVN_REV], ${ESVN_WC_REVISION})" > revision.m4
	echo "m4_define([SVN_DATE], ${CB_LCD})" >> revision.m4
	eautoreconf
}

src_configure() {
	setup-wxwidgets

	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable pch) \
		$(use_with contrib contrib-plugins all)
}

pkg_postinst() {
	elog "The Symbols Browser is disabled due to it causing crashes."
	elog "For more information see https://sourceforge.net/p/codeblocks/tickets/225/"

	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
