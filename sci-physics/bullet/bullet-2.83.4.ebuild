# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Continuous Collision Detection and Physics Library"
HOMEPAGE="http://www.bulletphysics.com/"
SRC_URI="https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+bullet3 doc double-precision examples extras"

RDEPEND="
	virtual/opengl
	media-libs/freeglut"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${PN}-2.78-soversion.patch )

S="${WORKDIR}/${PN}3-${PV}"

src_prepare() {
	# allow to generate docs
	sed -i -e 's/GENERATE_HTMLHELP.*//g' Doxyfile || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_CPU_DEMOS=OFF
		-DBUILD_OPENGL3_DEMOS=OFF
		-DBUILD_BULLET2_DEMOS=OFF
		-DUSE_GRAPHICAL_BENCHMARK=OFF
		-DINSTALL_LIBS=ON
		-DINSTALL_EXTRA_LIBS=ON
		$(cmake-utils_use_build bullet3 BULLET3)
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
	use doc && dodoc docs/*.pdf && dohtml -r html/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Extras examples
	fi
}
