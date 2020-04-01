# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-any-r1 multibuild cmake-utils

DESCRIPTION="A YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
SRC_URI="https://github.com/jbeder/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="MIT"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

BDEPEND="
	test? ( ${PYTHON_DEPS} )
"

RESTRICT="!test? ( test )"

CMAKE_MAKEFILE_GENERATOR=emake

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	MULTIBUILD_VARIANTS=(shared)
	use static-libs && MULTIBUILD_VARIANTS+=(static)

	cmake-utils_src_prepare
}

src_configure() {
	multibuild_foreach_variant yaml-cpp_configure
}

yaml-cpp_configure() {
	local -a mycmakeargs=(
		-DYAML_BUILD_SHARED_LIBS=$(
			if [[ ${MULTIBUILD_VARIANT} == shared ]]; then
				printf 'ON\n'
			else
				printf 'OFF\n'
			fi
		)
		-DYAML_CPP_BUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant yaml-cpp_test
}

yaml-cpp_test() {
	pushd "${BUILD_DIR}" >/dev/null || die
	pwd
	./test/run-tests || die "tests failed for ${MULTIBUILD_VARIANT} libs"
	popd >/dev/null || die
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
