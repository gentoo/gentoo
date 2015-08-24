# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit cmake-utils versionator

PV_MAJ=$(get_version_component_range 1-2)
MY_P=${PN}-linux-${PV}

DESCRIPTION="An enterprise quality optical character recognition (OCR) engine by Cognitive Technologies"
HOMEPAGE="https://launchpad.net/cuneiform-linux"
SRC_URI="https://launchpad.net/${PN}-linux/${PV_MAJ}/${PV_MAJ}/+download/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug +imagemagick graphicsmagick"

REQUIRED_USE="^^ ( imagemagick graphicsmagick )"

RDEPEND="imagemagick? ( media-gfx/imagemagick )
		graphicsmagick? ( media-gfx/graphicsmagick )"
DEPEND=">=dev-util/cmake-2.6.2
	${RDEPEND}"

DOCS="readme.txt"

S=${WORKDIR}/${MY_P}

src_prepare(){
	epatch "${FILESDIR}/c-assert.diff"
	epatch "${FILESDIR}/libm.diff"
	if use graphicsmagick; then
		epatch "${FILESDIR}/graphicsmagick.diff"
	fi
	# respect LDFLAGS
	sed -i 's:\(set[(]CMAKE_SHARED_LINKER_FLAGS "[^"]*\):\1 $ENV{LDFLAGS}:' \
		"${S}/cuneiform_src/CMakeLists.txt" || die "failed to sed for LDFLAGS"
	# Fix automagic dependencies / linking
	if ! use imagemagick; then
		sed -i "s:find_package(ImageMagick COMPONENTS Magick++):#DONOTFIND:" \
			"${S}/cuneiform_src/CMakeLists.txt" \
		|| die "Sed for ImageMagick automagic dependency failed."
	fi
}

src_install() {
	#default
	cmake-utils_src_install
	doman "${FILESDIR}/${PN}.1"
}
