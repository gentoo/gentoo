# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/schroedinger/schroedinger-1.0.11-r1.ebuild,v 1.7 2015/01/21 11:41:25 pacho Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit eutils autotools-multilib gnome2-utils

DESCRIPTION="C-based libraries for the Dirac video codec"
HOMEPAGE="http://www.diracvideo.org/"
SRC_URI="http://www.diracvideo.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc-am"

src_prepare() {
	gnome2_environment_reset #534582

	# from upstream, drop at next release
	epatch "${FILESDIR}"/${P}-darwin-compile.patch

	sed -i \
		-e '/AS_COMPILER_FLAG(-O3/d' \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		configure.ac || die

	AT_M4DIR="m4" autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html"
	)
	autotools-multilib_src_configure
}
