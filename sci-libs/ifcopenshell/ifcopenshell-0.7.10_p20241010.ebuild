# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake python-single-r1

COMMIT=ed8cbff3d253691ac81450eaf16cad46bf6149e5
SVGFILL_COMMIT=5843c9acad36d1b71e8199760e00681849f17207

DESCRIPTION="IFC toolkit and geometry engine"
HOMEPAGE="https://ifcopenshell.org/"
SRC_URI="
	https://github.com/IfcOpenShell/IfcOpenShell/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/IfcOpenShell/svgfill/archive/${SVGFILL_COMMIT}.tar.gz -> ${PN}-svgfill-${SVGFILL_COMMIT:0:8}.tar.gz
"
S="${WORKDIR}/IfcOpenShell-${COMMIT}"
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
	dev-cpp/nlohmann_json
	dev-cpp/svgpp
"

src_prepare() {
	mv "${WORKDIR}"/svgfill-${SVGFILL_COMMIT}/* "${S}"/src/svgfill/ || die
	cmake_src_prepare
}

src_configure() {
	# https://docs.ifcopenshell.org/ifcopenshell/installation.html
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/ifcopenshell
		-DCMAKE_SKIP_RPATH=ON
		-DCOLLADA_SUPPORT=OFF
		-DHDF5_SUPPORT=OFF
		-DGMP_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		-DMPFR_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		-DOCC_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)/opencascade"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
