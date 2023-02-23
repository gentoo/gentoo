# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

OC_COMMIT=119fe41a83bc455a24a11ecc9b78e7b13fcfcc45
GT_COMMIT=2ad076167a676e3ed62f90b754b30fac5caa1f88

PYTHON_COMPAT=( python3_{10..11} )

inherit flag-o-matic python-single-r1 cmake

DESCRIPTION="Simple Theorem Prover, an efficient SMT solver for bitvectors"
HOMEPAGE="https://stp.github.io/
	https://github.com/stp/stp/"
SRC_URI="
	https://github.com/stp/stp/archive/${PV}.tar.gz
		-> ${P}.tar.gz
	test? (
		https://github.com/stp/OutputCheck/archive/${OC_COMMIT}.tar.gz
			-> ${P}_OutputCheck.tar.gz
		https://github.com/stp/googletest/archive/${GT_COMMIT}.tar.gz
			-> ${P}_gtest.tar.gz
	)
"

LICENSE="GPL-2+ MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="cryptominisat debug +python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	sci-mathematics/minisat:=
	sys-libs/zlib:=
	cryptominisat? (
		dev-db/sqlite:3
		dev-libs/icu:=
		sci-mathematics/cryptominisat:=
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	test? ( dev-python/lit )
"

PATCHES=(
	"${FILESDIR}"/${P}-CMakeLists.txt-fix_cflags.patch
	"${FILESDIR}"/${P}-cstdint.patch
	"${FILESDIR}"/${P}-stp.py-library_path.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${P}.tar.gz

	if use test ; then
		local i
		for i in OutputCheck gtest ; do
			tar xf "${DISTDIR}"/${P}_${i}.tar.gz --strip-components=1  \
				-C "${S}"/utils/${i}  || die "failed to unpack ${i}"
		done
	fi
}

src_prepare() {
	# Replace static lib with get_libdir
	sed -i "s/set(LIBDIR lib/set(LIBDIR $(get_libdir)/" CMakeLists.txt || die

	# Remove problematic test
	rm "${S}"/tests/query-files/misc-tests/no-query.cvc || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr warnings, bug #863263
	filter-lto

	local CMAKE_BUILD_TYPE
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	local -a mycmakeargs=(
		-DTEST_C_API=OFF  # C API test fail
		-DNOCRYPTOMINISAT=$(usex cryptominisat 'OFF' 'ON')  # double negation
		-DENABLE_PYTHON_INTERFACE=$(usex python)
		-DENABLE_ASSERTIONS=$(usex test)
		-DENABLE_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Because Python files for tests (in BUILD_DIR) and those installed on the
	# system differ, and are generated upon install, we have to wait for CMake
	# to install them into the temporary image.
	use python && python_optimize "${D}/$(python_get_sitedir)"/stp

	mv "${D}"/usr/man "${D}"/usr/share/man || die
	dodoc -r papers
}
