# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit cmake toolchain-funcs flag-o-matic distutils-r1

DESCRIPTION="A data templating language for app and tool developers"
HOMEPAGE="https://jsonnet.org/"
SRC_URI="https://github.com/google/jsonnet/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="custom-optimization doc examples python test"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"
RDEPEND="
	dev-cpp/rapidyaml:=
	dev-cpp/nlohmann_json:=
	python? ( ${PYTHON_DEPS} )
"

DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

BDEPEND="
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/jsonnet-0.12.1-dont-call-make-from-setuppy.patch"
	"${FILESDIR}/jsonnet-0.16.0-libdir.patch"
	"${FILESDIR}/jsonnet-0.16.0-cp-var.patch"
	"${FILESDIR}/jsonnet-0.18.0-unbundle.patch"
)

distutils_enable_tests unittest

src_prepare() {
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	use custom-optimization || replace-flags '-O*' -O3
	tc-export CC CXX

	local mycmakeargs=(
		-DUSE_SYSTEM_JSON=ON
		-DBUILD_STATIC_LIBS=OFF
	)

	if use test; then
		mycmakeargs+=(
			-DBUILD_TESTS=ON
			-DUSE_SYSTEM_GTEST=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_TESTS=OFF
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use python && CMAKE_BUILD_DIR="${BUILD_DIR}" distutils-r1_src_compile
}

src_test() {
	cmake_src_test
	use python && CMAKE_BUILD_DIR="${BUILD_DIR}" distutils-r1_src_test
}

python_test() {
	LD_LIBRARY_PATH="${CMAKE_BUILD_DIR}" "${EPYTHON}" -m unittest python._jsonnet_test -v \
		|| die "Tests failed with ${EPYTHON}"
}

src_install() {
	cmake_src_install
	use python && distutils-r1_src_install

	if use doc; then
		find doc -name '.gitignore' -delete || die
		docinto html
		dodoc -r doc/.
	fi
	if use examples; then
		docinto examples
		dodoc -r examples/.
	fi
}
