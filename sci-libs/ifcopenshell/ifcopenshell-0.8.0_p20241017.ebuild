# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_12 )
inherit cmake python-single-r1

COMMIT=0e5008d21eb63e27bc01c23c04e00926fa893225
CITYJSON_COMMIT=9e0bc8c2a8ad5551843263d8fd8e69191ee3a69e
SVGFILL_COMMIT=80155ec08824c7db097273c979e8db34dce32987

DESCRIPTION="IFC toolkit and geometry engine"
HOMEPAGE="https://ifcopenshell.org/"
SRC_URI="
	https://github.com/IfcOpenShell/IfcOpenShell/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/IfcOpenShell/ifc-to-cityjson/archive/${CITYJSON_COMMIT}.tar.gz -> cityjson-20240821.tar.gz
	https://github.com/IfcOpenShell/svgfill/archive/${SVGFILL_COMMIT}.tar.gz -> svgfill-20240824.tar.gz
"
S="${WORKDIR}/IfcOpenShell-${COMMIT}"
CMAKE_USE_DIR="${S}/cmake"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libxml2
"
DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	media-libs/svgpp
"

# Build-time dependencies that are executed during the emerge process, and
# only need to be present in the native build system (CBUILD). Example:
#BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/install-cityjson.patch" )

src_prepare() {
	cmake_src_prepare
	mv "${WORKDIR}"/ifc-to-cityjson-${CITYJSON_COMMIT}/* ${S}/src/ifcconvert/cityjson/ || die
	mv "${WORKDIR}"/svgfill-${SVGFILL_COMMIT}/* ${S}/src/svgfill/ || die
	cd ${S}/src/svgfill/ || die
	eapply "${FILESDIR}/svgfill-install-dirs.patch"
}

src_configure() {
	# https://docs.ifcopenshell.org/ifcopenshell/installation.html
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DCOLLADA_SUPPORT=OFF
		-DHDF5_SUPPORT=OFF
		-DOCC_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)/opencascade"
		-DGMP_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		-DMPFR_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		-DEIGEN_DIR="${ESYSROOT}/usr/include/eigen3"
	)
	cmake_src_configure
}

src_install() {
    cmake_src_install
    python_optimize
}
