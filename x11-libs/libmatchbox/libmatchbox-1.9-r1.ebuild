# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libmatchbox/libmatchbox-1.9-r1.ebuild,v 1.8 2014/08/10 20:06:29 slyfox Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="The Matchbox Library"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/${PV}/${P}.tar.bz2
	mirror://sourceforge/check/check-0.9.12.tar.gz" # For check.m4

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ppc x86"
IUSE="debug doc jpeg pango png static-libs test truetype X xsettings"

RDEPEND="x11-libs/libXext:=
	truetype? ( x11-libs/libXft:= )
	pango? ( x11-libs/pango:= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	xsettings? ( x11-libs/libxsettings-client )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"

# Test suite broken, missing files and such.
RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README )

pkg_setup() {
	# Bug #138135
	if use truetype && use pango; then
		ewarn "You have both the truetype and pango USE flags set, pango"
		ewarn "overrides and disables the XFT support truetype enables."
		ewarn "If this isn't what you intended you should stop the build!"
	fi
}

src_prepare() {
	mv "${WORKDIR}"/check-*/check.m4 "${WORKDIR}"/ || die

	epatch \
		"${FILESDIR}"/${P}-libpng1{4,5}.patch \
		"${FILESDIR}"/${P}-underlinking.patch

	AT_M4DIR="${WORKDIR}" eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug) \
		$(use_enable doc doxygen-docs) \
		$(use_enable truetype xft) \
		$(use_enable pango) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable xsettings) \
		$(use_with X x) \
		$(use_enable test unit-tests)
}

src_install() {
	default
	use doc && dohtml doc/html/*

	prune_libtool_files --all
}
