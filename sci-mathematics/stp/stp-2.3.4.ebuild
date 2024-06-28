# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit flag-o-matic python-single-r1 cmake

DESCRIPTION="Simple Theorem Prover, an efficient SMT solver for bitvectors"
HOMEPAGE="https://stp.github.io/
	https://github.com/stp/stp/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/stp/stp.git"
else
	SRC_URI="https://github.com/stp/stp/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+ MIT"
SLOT="0/${PV}"
IUSE="cryptominisat debug +python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) test? ( python )"
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
	python? (
		${PYTHON_DEPS}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-apps/help2man
	test? (
		dev-cpp/gtest
		dev-python/OutputCheck
		dev-python/lit
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.3-CMakeLists.txt-fix_cflags.patch"
	"${FILESDIR}/${PN}-2.3.3-stp.py-library_path.patch"
	"${FILESDIR}/${PN}-2.3.4-gtest.patch"
	"${FILESDIR}/${PN}-2.3.4-lit-cfg.patch"
)

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
	fi
}

src_configure() {
	# -Werror=odr warnings, bug #863263
	filter-lto

	local CMAKE_BUILD_TYPE
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local -a mycmakeargs=(
		-DUSE_RISS=OFF

		# Cryptominisat switches
		-DNOCRYPTOMINISAT=$(usex cryptominisat 'OFF' 'ON')  # double negation
		-DFORCE_CMS=$(usex cryptominisat)

		-DENABLE_PYTHON_INTERFACE=$(usex python)
		-DENABLE_ASSERTIONS=$(usex test)
		-DENABLE_TESTING=$(usex test)
	)

	if use test ; then
		mycmakeargs+=(
			-DTEST_C_API=OFF  # C API test fail
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Because Python files for tests (in BUILD_DIR) and those installed on the
	# system differ, and are generated upon install, we have to wait for CMake
	# to install them into the temporary image.
	if use python ; then
		python_optimize "${D}/$(python_get_sitedir)/stp"
	fi

	mv "${D}/usr/man" "${D}/usr/share/man" || die
	dodoc -r papers
}
