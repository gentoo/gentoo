# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-single-r1

MY_PN=ifcopenshell-python
MY_P=${MY_PN}-${PV}

CITYJSON_COMMIT=a9488c8d8fd1c32eb23118596819ab54225cdfb4
SVGFILL_COMMIT=29fbc17edec61b4f774ba8e87d4308983a75fc90

DESCRIPTION="IFC toolkit and geometry engine"
HOMEPAGE="https://ifcopenshell.org/"
SRC_URI="
	https://github.com/IfcOpenShell/IfcOpenShell/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tar.gz
	https://github.com/IfcOpenShell/ifc-to-cityjson/archive/${CITYJSON_COMMIT}.tar.gz -> ${PN}-cityjson-${CITYJSON_COMMIT:0:8}.tar.gz
	https://github.com/IfcOpenShell/svgfill/archive/${SVGFILL_COMMIT}.tar.gz -> ${PN}-svgfill-${SVGFILL_COMMIT:0:8}.tar.gz
"
S="${WORKDIR}/IfcOpenShell-${MY_P}"
CMAKE_USE_DIR="${S}/cmake"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"  # tests need an additonal Git submodule

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost
	dev-libs/gmp
	dev-libs/libxml2
	dev-libs/mpfr
	sci-libs/opencascade:=
	sci-mathematics/cgal
	$(python_gen_cond_dep '
		dev-python/isodate[${PYTHON_USEDEP}]
		dev-python/lark[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/shapely[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	dev-cpp/eigen
	dev-cpp/nlohmann_json
	dev-cpp/svgpp
"

src_prepare() {
	mv "${WORKDIR}"/ifc-to-cityjson-${CITYJSON_COMMIT}/* "${S}"/src/ifcconvert/cityjson/ || die
	mv "${WORKDIR}"/svgfill-${SVGFILL_COMMIT}/* "${S}"/src/svgfill/ || die
	sed -i "s/version = \"0.0.0\"/version = \"${PV}\"/" "${S}"/src/ifcopenshell-python/ifcopenshell/__init__.py || die
	cmake_src_prepare
}

src_configure() {
	# https://docs.ifcopenshell.org/ifcopenshell/installation.html
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/ifcopenshell
		-DCMAKE_SKIP_RPATH=ON
		-DCOLLADA_SUPPORT=OFF
		-DHDF5_SUPPORT=OFF
		-DEIGEN_DIR="${ESYSROOT}/usr/include/eigen3"
		-DGMP_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		-DMPFR_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		-DOCC_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)/opencascade"
		-DVERSION_OVERRIDE=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
