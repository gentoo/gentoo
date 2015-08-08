# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="C library for the Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://sfml.sourceforge.net/"
SRC_URI="mirror://sourceforge/sfml/SFML-${PV}-c-sdk-linux-32.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="~media-libs/libsfml-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SFML-${PV}/CSFML"

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch
}

src_compile() {
	emake CPP=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr libdir=/usr/$(get_libdir) install
	use doc && dohtml doc/html/*
}
