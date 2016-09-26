# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Stream based read/write library for COLLADA files"
HOMEPAGE="http://www.opencollada.org/"
SRC_URI="https://github.com/KhronosGroup/OpenCOLLADA/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 ~ppc64 ~x86"

IUSE="expat static-libs"

# This is still needed to have so version numbers
MY_SOVERSION="1.6"

RDEPEND="dev-libs/libpcre
	dev-libs/zziplib
	media-libs/lib3ds
	sys-libs/zlib
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/OpenCOLLADA-${PV}
# This is needed or you get an error on install
BUILD_DIR="${S}"/build

PATCHES=(
	"${FILESDIR}"/${PN}-0_p864-expat.patch
	"${FILESDIR}"/${PN}-1.2.2-soversion.patch
	"${FILESDIR}"/${PN}-1.2.2-no-undefined.patch
	"${FILESDIR}"/${PN}-1.2.2-libdir.patch
)

src_prepare() {
	edos2unix CMakeLists.txt

	default

	# Remove bundled depends that have portage equivalents
	rm -rv Externals/{expat,lib3ds,LibXML,pcre,zlib,zziplib} || die

	# Remove unused build systems
	rm -v Makefile scripts/{unixbuild.sh,vcproj2cmake.rb} || die
	find "${S}" -name SConscript -delete || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SHARED=ON
		-DUSE_STATIC=$(usex static-libs ON OFF)
		-DUSE_EXPAT=$(usex expat ON OFF)
		-DUSE_LIBXML=$(usex !expat ON OFF)
		-Dsoversion=${MY_SOVERSION}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	echo "LDPATH=/usr/$(get_libdir)/opencollada" > "${T}"/99${PN} || die "echo failed"
	doenvd "${T}"/99${PN}

	dobin build/bin/OpenCOLLADAValidator
}
