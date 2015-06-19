# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fmod/fmod-3.75.ebuild,v 1.4 2014/11/30 12:31:23 pacho Exp $

MY_P="fmodapi${PV/.}linux"
S=${WORKDIR}/${MY_P}
DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org/"
SRC_URI="http://www.fmod.org/files/${MY_P}.tar.gz"

LICENSE="BSD fmod-3.75" # BSD is for OggVorbis from README.txt
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

RESTRICT="strip"

src_install() {
	dolib api/libfmod-${PV}.so
	dosym /usr/lib/libfmod-${PV}.so /usr/lib/libfmod.so

	insinto /usr/include
	doins api/inc/*

	insinto /usr/share/${PN}/media
	doins media/* || die "doins failed"
	cp -r samples "${D}/usr/share/${PN}/" || die "cp failed"

	dohtml -r documentation/*
	dodoc README.TXT documentation/Revision.txt
}
