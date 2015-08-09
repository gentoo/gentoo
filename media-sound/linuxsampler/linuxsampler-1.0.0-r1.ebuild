# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc jack sqlite static-libs"

RDEPEND="sqlite? ( >=dev-db/sqlite-3.3 )
	>=media-libs/libgig-3.3.0
	media-libs/alsa-lib
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_configure() {
	econf --enable-alsa-driver \
		--disable-arts-driver \
		$(use_enable jack jack-driver) \
		$(use_enable sqlite instruments-db) \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	if use doc; then
		emake docs
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	if use doc; then
		dohtml -r doc/html/*
	fi

	prune_libtool_files
}
