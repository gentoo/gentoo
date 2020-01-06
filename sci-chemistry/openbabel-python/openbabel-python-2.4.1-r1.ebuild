# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit cmake-utils python-r1

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
SLOT="0/5"
LICENSE="GPL-2"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	~sci-chemistry/openbabel-${PV}
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2"

S="${WORKDIR}"/openbabel-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.2-gcc-6_and_7-backport.patch
	)

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e "s:\"\.\.\":\"${EPREFIX}/usr\":g" \
		-i test/testbabel.py || die
	swig -python -c++ -small -O -templatereduce -naturalvar \
		-I"${EPREFIX}/usr/include/openbabel-2.0" \
		-o scripts/python/openbabel-python.cpp \
		-DHAVE_EIGEN \
		-outdir scripts/python \
		scripts/openbabel-python.i \
		|| die "Regeneration of openbabel-python.cpp failed"
	sed \
		-e '/__GNUC__/s:== 4:>= 4:g' \
		-i include/openbabel/shared_ptr.h || die
}

src_configure() {
	my_impl_src_configure() {
		local mycmakeargs=(
			-DCMAKE_INSTALL_RPATH=
			-DBINDINGS_ONLY=ON
			-DBABEL_SYSTEM_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libopenbabel.so"
			-DOB_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/openbabel/${PV}"
			-DLIB_INSTALL_DIR="${D}$(python_get_sitedir)"
			-DPYTHON_BINDINGS=ON
			-DPYTHON_EXECUTABLE=${PYTHON}
			-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DPYTHON_INCLUDE_PATH="$(python_get_includedir)"
			-DPYTHON_LIBRARY="$(python_get_library_path)"
			-DENABLE_TESTS=ON
			-DCMAKE_INSTALL_PREFIX="${ED%/}/usr"
		)

		cmake-utils_src_configure
	}

	python_foreach_impl my_impl_src_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_make bindings_python
}

src_test() {
	python_foreach_impl cmake-utils_src_test -R py
}

src_install() {
	my_impl_src_install() {
		cd "${BUILD_DIR}" || die

		cmake -DCOMPONENT=bindings_python -P cmake_install.cmake

		python_optimize
	}

	python_foreach_impl my_impl_src_install
}
