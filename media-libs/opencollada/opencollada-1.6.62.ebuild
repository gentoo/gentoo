# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic versionator

DESCRIPTION="Stream based read/write library for COLLADA files"
HOMEPAGE="http://www.opencollada.org/"
SRC_URI="https://github.com/KhronosGroup/OpenCOLLADA/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="static-libs"

RDEPEND="dev-libs/libpcre
	dev-libs/zziplib
	media-libs/lib3ds
	sys-libs/zlib
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/OpenCOLLADA-${PV}"

PATCHES=( "${FILESDIR}/${P}-cmake-fixes.patch" )

src_prepare() {
	edos2unix CMakeLists.txt

	cmake-utils_src_prepare

	# Remove bundled depends that have portage equivalents
	rm -rv Externals/{expat,lib3ds,LibXML,pcre,zziplib} || die

	# Remove unused build systems
	rm -v Makefile scripts/{unixbuild.sh,vcproj2cmake.rb} || die
	find "${S}" -name SConscript -delete || die
}

src_configure() {
	# bug 619670
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DUSE_SHARED=ON
		-DUSE_STATIC=$(usex static-libs)
		-DUSE_LIBXML=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	echo "LDPATH=/usr/$(get_libdir)/opencollada" > "${T}"/99${PN} || die "echo failed"
	doenvd "${T}"/99${PN}

	dobin "${BUILD_DIR}/bin/DAEValidator"
	dobin "${BUILD_DIR}/bin/OpenCOLLADAValidator"
	# Need to be in same directory as above binaries
	docinto "/usr/bin"
	dodoc "${BUILD_DIR}/bin/COLLADAPhysX3Schema.xsd"
	dodoc "${BUILD_DIR}/bin/collada_schema_1_4_1.xsd"
	dodoc "${BUILD_DIR}/bin/collada_schema_1_5.xsd"
}
