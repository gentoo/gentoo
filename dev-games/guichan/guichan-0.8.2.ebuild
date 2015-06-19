# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/guichan/guichan-0.8.2.ebuild,v 1.8 2015/03/31 19:03:28 mr_bones_ Exp $

EAPI=5
inherit eutils autotools

DESCRIPTION="a portable C++ GUI library designed for games using Allegro, SDL and/or OpenGL"
HOMEPAGE="http://guichan.sourceforge.net/"
SRC_URI="http://guichan.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="allegro opengl sdl static-libs"

DEPEND="allegro? ( <media-libs/allegro-5 )
	opengl? ( virtual/opengl )
	sdl? (
		media-libs/libsdl
		media-libs/sdl-image
	)"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-automake-1.13.patch
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable allegro) \
		$(use_enable opengl) \
		$(use_enable sdl) \
		$(use_enable sdl sdlimage) \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
