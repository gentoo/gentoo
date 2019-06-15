# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# According to upstream is compatible with 2.7 and 3.x
# However support for python3_7 needs boost with python3_7
PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit cmake-utils python-single-r1

DESCRIPTION="Seamless operability between C++11 and Python"
HOMEPAGE="https://pybind11.readthedocs.io/en/stable/"
SRC_URI="https://github.com/pybind/pybind11/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc test"

RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEP}
	doc? (
		dev-python/breathe[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-cpp/catch:0
		dev-libs/boost[python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	${PYTHON_DEP}
	dev-cpp/eigen:3
	sys-apps/texinfo
	sys-devel/gettext[cxx]
	virtual/man
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( README.md CONTRIBUTING.md ISSUE_TEMPLATE.md )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		-DPYBIND11_INSTALL=ON
		-DPYBIND11_TEST=$(usex test)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	# documentation is not covered by cmake, but has it's own makefile
	# using sphinx
	if use doc; then
		pushd "${S}"/docs || die
		emake info man html
		popd || die
	fi
}

src_test() {
	cmake-utils_src_test
	pushd "${BUILD_DIR}" || die
	eninja check
	popd || die
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		local HTML_DOCS=( "${S}"/docs/.build/html/. )
		einstalldocs

		# install man and info pages
		doman "${S}"/docs/.build/man/pybind11.1
		doinfo "${S}"/docs/.build/texinfo/pybind11.info
	fi
}
