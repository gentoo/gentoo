# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/bullet/bullet-2.80.ebuild,v 1.6 2012/12/04 10:30:30 ago Exp $

EAPI=4

inherit eutils cmake-utils

# version release, check http://code.google.com/p/bullet/downloads/list
MYP=${P}-rev2531

DESCRIPTION="Continuous Collision Detection and Physics Library"
HOMEPAGE="http://www.bulletphysics.com/"
SRC_URI="http://bullet.googlecode.com/files/${MYP}.tgz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc double-precision examples extras"

RDEPEND="virtual/opengl
	media-libs/freeglut"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${PN}-2.78-soversion.patch )

S="${WORKDIR}/${MYP}"

src_prepare() {
	# allow to generate docs
	sed -i -e 's/GENERATE_HTMLHELP.*//g' Doxyfile || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_CPU_DEMOS=OFF
		-DBUILD_DEMOS=OFF
		-DUSE_GRAPHICAL_BENCHMARK=OFF
		-DINSTALL_LIBS=ON
		-DINSTALL_EXTRA_LIBS=ON
		$(cmake-utils_use_build extras EXTRAS)
		$(cmake-utils_use_use double-precision DOUBLE_PRECISION)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen || die
	fi
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc *.pdf && dohtml -r html/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Extras Demos
	fi
}
