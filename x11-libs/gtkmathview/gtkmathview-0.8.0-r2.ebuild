# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Rendering engine for MathML documents"
HOMEPAGE="http://helm.cs.unibo.it/mml-widget/"
SRC_URI="http://helm.cs.unibo.it/mml-widget/sources/${P}.tar.gz"

LICENSE="LGPL-3"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="gtk mathml svg t1lib"

RDEPEND=">=dev-libs/glib-2.2.1:2
	>=dev-libs/popt-1.7
	>=dev-libs/libxml2-2.6.7:2
	gtk? ( >=x11-libs/gtk+-2.2.1:2
		>=media-libs/t1lib-5:5
		x11-libs/pango
		|| ( x11-libs/pangox-compat <x11-libs/pango-1.31[X] ) )
	mathml? ( media-fonts/texcm-ttf )
	t1lib?	( >=media-libs/t1lib-5:5 )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig"

DOCS="ANNOUNCEMENT AUTHORS BUGS ChangeLog CONTRIBUTORS HISTORY NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-cond-t1.patch

	# Fix building against libxml2[icu], bug #356095
	epatch "${FILESDIR}"/${P}-fix-template.patch

	# Fix building with gold, bug #369117; requires eautoreconf
	epatch "${FILESDIR}/${P}-underlinking.patch"

	epatch "${FILESDIR}/${P}-gcc47.patch"

	# m4 macros from upstream git, required for eautoreconf
	if [[ ! -d ac-helpers ]]; then
		mkdir ac-helpers || die "mkdir failed"
		cp "${FILESDIR}/binreloc.m4" ac-helpers || die "cp failed"
	fi

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die

	AT_M4DIR=ac-helpers eautoreconf
}

src_configure() {
	# --disable-popt will build only the library and not the frontend
	# TFM is needed for SVG, default value is 2
	econf $(use_enable gtk) \
		$(use_enable svg) \
		$(use_with t1lib) \
		--with-popt \
		--enable-libxml2 \
		--enable-libxml2-reader \
		--enable-ps \
		--enable-tfm=2 \
		--enable-builder-cache \
		--enable-breaks \
		--enable-boxml \
		--disable-gmetadom \
		--disable-static
}

src_install() {
	default
	prune_libtool_files
}
