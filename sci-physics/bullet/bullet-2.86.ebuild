# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Continuous Collision Detection and Physics Library"
HOMEPAGE="http://www.bulletphysics.com/"
SRC_URI="https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+bullet3 doc double-precision examples extras test"

RDEPEND="
	virtual/opengl
	media-libs/freeglut"

DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${PN}-2.85-soversion.patch )

DOCS=( AUTHORS.txt LICENSE.txt README.md )

# Building / linking of third Party library BussIK does not work out of the box
RESTRICT="test"

S="${WORKDIR}/${PN}3-${PV}"

src_prepare() {
	cmake-utils_src_prepare

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
		-DBUILD_BULLET3=$(usex bullet3)
		-DBUILD_EXTRAS=$(usex extras)
		-DUSE_DOUBLE_PRECISION=$(usex double-precision)
		-DBUILD_UNIT_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		doxygen || die
		HTML_DOCS+=( html/. )
		DOCS+=( docs/*.pdf )
	fi
}

src_install() {
	cmake-utils_src_install
	use examples && DOCS+=( examples )
	einstalldocs
}
