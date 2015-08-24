# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="OpenGTL-${PV}"

inherit cmake-utils

DESCRIPTION="Collection of libraries for graphics transformation algorithms"
HOMEPAGE="http://opengtl.org/"
SRC_URI="http://download.opengtl.org/${MY_P}.tar.bz2 https://dev.gentoo.org/~creffett/distfiles/${PN}-0.9.18-llvm-3.3.patch"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug test"

RDEPEND="
	media-libs/libpng:0=
	(
		<sys-devel/llvm-3.4
		>=sys-devel/llvm-3.1
	)
"
DEPEND="${RDEPEND}
	app-text/ghostscript-gpl
	test? ( dev-util/lcov )
"

RESTRICT="test"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-0.9.18-memcpy.patch"
	"${FILESDIR}/${PN}-0.9.18-underlinking.patch"
)

src_prepare() {
	if has_version ">=sys-devel/llvm-3.3"; then
		epatch "${DISTDIR}/${PN}-0.9.18-llvm-3.3.patch"
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
		$(cmake-utils_use debug OPENGTL_ENABLE_DEBUG_OUTPUT)
		$(cmake-utils_use test OPENGTL_BUILD_TESTS)
		$(cmake-utils_use test OPENGTL_CODE_COVERAGE)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newdoc OpenShiva/doc/reference/region.pdf OpenShiva.pdf
}
