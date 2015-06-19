# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/cegui/cegui-0.6.2b.ebuild,v 1.13 2015/04/19 06:41:02 mr_bones_ Exp $

EAPI=5
inherit autotools eutils

MY_P=CEGUI-${PV%b}
DESCRIPTION="Crazy Eddie's GUI System"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}b.tar.gz
	doc? ( mirror://sourceforge/crayzedsgui/${MY_P}-DOCS.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug devil directfb doc examples expat irrlicht lua opengl xerces-c xml"

RDEPEND="dev-libs/libpcre
	media-libs/freetype:2
	devil? ( media-libs/devil )
	directfb? ( dev-libs/DirectFB )
	expat? ( dev-libs/expat )
	irrlicht? ( dev-games/irrlicht )
	lua? (
		dev-lang/lua
		dev-lua/toluapp
	)
	opengl? (
		virtual/opengl
		media-libs/freeglut
		media-libs/glew
	)
	xerces-c? ( dev-libs/xerces-c )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-dups.patch \
		"${FILESDIR}"/${P}-gcc46.patch
	sed -i \
		-e 's/ILvoid/void/g' \
		ImageCodecModules/DevILImageCodec/CEGUIDevILImageCodec.cpp || die
	if use examples ; then
		cp -r Samples Samples.clean || die
		rm -f $(find Samples.clean -name 'Makefile*') || die
		rm -rf Samples.clean/bin || die
	fi
	eautoreconf #220040
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable devil) \
		$(use_enable directfb directfb-renderer) \
		$(use_enable examples samples) \
		$(use_enable expat) \
		$(use_enable irrlicht irrlicht-renderer) \
		$(use_enable lua external-toluapp) \
		$(use_enable lua lua-module) \
		$(use_enable lua toluacegui) \
		$(use_enable opengl external-glew) \
		$(use_enable opengl opengl-renderer) \
		$(use_enable xerces-c) \
		$(use_enable xml libxml) \
		--enable-static \
		--enable-tga \
		--enable-tinyxml \
		--disable-corona \
		--disable-dependency-tracking \
		--disable-external-tinyxml \
		--disable-freeimage \
		--disable-samples \
		--disable-silly \
		--without-gtk2 \
		--without-ogre-renderer
}

src_install() {
	default
	if use doc ; then
		dohtml -r documentation/api_reference
		dodoc documentation/*.pdf
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/Samples
		doins -r Samples.clean/*
	fi
}
