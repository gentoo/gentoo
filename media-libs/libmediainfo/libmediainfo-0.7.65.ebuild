# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmediainfo/libmediainfo-0.7.65.ebuild,v 1.3 2014/01/26 11:09:08 ago Exp $

EAPI=5

inherit autotools eutils flag-o-matic multilib

MY_PN="MediaInfo"
DESCRIPTION="MediaInfo libraries"
HOMEPAGE="http://mediaarea.net/mediainfo/"
SRC_URI="mirror://sourceforge/mediainfo/${PN}_${PV}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="curl doc mms static-libs"

RDEPEND="sys-libs/zlib
	dev-libs/tinyxml2
	>=media-libs/libzen-0.4.28[static-libs=]
	curl? ( net-misc/curl )
	mms? ( >=media-libs/libmms-0.6.1[static-libs=] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_PN}Lib/Project/GNU/Library

src_prepare() {
	sed -i 's:-O2::' configure.ac || die
	append-cppflags -DMEDIAINFO_LIBMMS_DESCRIBE_SUPPORT=0

	epatch "${FILESDIR}"/${PN}-0.7.63-pkgconfig.patch

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--with-libtinyxml2 \
		$(use_with curl libcurl) \
		$(use_with mms libmms) \
		$(use_enable static-libs static) \
		$(use_enable static-libs staticlibs)
}

src_compile() {
	default

	if use doc; then
		cd "${WORKDIR}"/${MY_PN}Lib/Source/Doc
		doxygen Doxyfile || die
	fi
}

src_install() {
	default

	edos2unix ${PN}.pc #414545
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Archive Audio Duplicate Export Image Multiple Reader Tag Text Video; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}/${x}/*.h
	done

	insinto /usr/include/${MY_PN}DLL
	doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}DLL/*.h

	dodoc "${WORKDIR}"/${MY_PN}Lib/*.txt
	if use doc; then
		dohtml -r "${WORKDIR}"/${MY_PN}Lib/Doc/*
	fi

	prune_libtool_files
}
