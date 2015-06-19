# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/codeblocks/codeblocks-9999.ebuild,v 1.7 2014/08/10 21:26:29 slyfox Exp $

EAPI="5"
WX_GTK_VER="2.8"

inherit autotools eutils subversion wxwidgets

DESCRIPTION="The open source, cross platform, free C++ IDE"
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
SRC_URI=""
ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"

IUSE="contrib debug pch static-libs"

RDEPEND="app-arch/zip
	x11-libs/wxGTK:2.8[X]
	contrib? (
		app-text/hunspell
		dev-libs/boost:=
		dev-libs/libgamin
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	# Let's make the autorevision work.
	subversion_wc_info
	CB_LCD=$(LC_ALL=C svn info "${ESVN_WC_PATH}" | grep "^Last Changed Date:" | cut -d" " -f4,5)
	echo "m4_define([SVN_REV], ${ESVN_WC_REVISION})" > revision.m4
	echo "m4_define([SVN_DATE], ${CB_LCD})" >> revision.m4
	eautoreconf
}

src_configure() {
	econf \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable debug) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		$(use_with contrib contrib-plugins all)
}

src_compile() {
	emake clean-zipfiles
	emake
}

src_install() {
	default
	prune_libtool_files
}
