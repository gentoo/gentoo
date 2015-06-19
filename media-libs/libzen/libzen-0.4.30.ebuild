# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libzen/libzen-0.4.30.ebuild,v 1.2 2015/01/08 04:55:47 radhermit Exp $

EAPI=5

inherit autotools multilib eutils

MY_PN="ZenLib"
DESCRIPTION="Shared library for libmediainfo and mediainfo"
HOMEPAGE="http://sourceforge.net/projects/zenlib"
SRC_URI="mirror://sourceforge/zenlib/${PN}_${PV}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc static-libs"

DEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_PN}/Project/GNU/Library

src_prepare() {
	sed -i 's:-O2::' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-unicode \
		--enable-shared \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use doc ; then
		cd "${WORKDIR}"/${MY_PN}/Source/Doc
		doxygen Doxyfile || die
	fi
}

src_install() {
	default

	# remove since the pkgconfig file should be used instead
	rm "${D}"/usr/bin/libzen-config

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Format/Html Format/Http HTTP_Client ; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}/Source/${MY_PN}/${x}/*.h
	done

	dodoc "${WORKDIR}"/${MY_PN}/History.txt
	if use doc ; then
		dohtml "${WORKDIR}"/${MY_PN}/Doc/*
	fi

	prune_libtool_files
}
