# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="igsc"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-any-r1

DESCRIPTION="Intel graphics system controller firmware update library"
HOMEPAGE="https://github.com/intel/igsc"
SRC_URI="https://github.com/intel/${MY_PN}/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+cli doc"

RDEPEND="dev-libs/metee:="
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		${PYTHON_DEPS}
		app-doc/doxygen
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
	)
"

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CLI="$(usex cli)"
		-DENABLE_DOCS="$(usex doc)"
		-DENABLE_PERF="OFF"
		-DENABLE_WERROR="OFF"

		# If enabled, tests are automatically run during
		# the compile phase and we cannot run them because
		# they require permissions to access the hardware.
		-DENABLE_TESTS="OFF"
	)

	cmake_src_configure
}
