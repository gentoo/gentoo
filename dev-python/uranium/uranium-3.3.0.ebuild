# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit cmake-utils python-single-r1

MY_PN="Uranium"

DESCRIPTION="A Python framework for building 3D printing related applications"
HOMEPAGE="https://github.com/Ultimaker/Uranium"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libarcus:=[python,${PYTHON_USEDEP}]
	<dev-python/PyQt5-5.10[${PYTHON_USEDEP},declarative,network,svg]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/scipy-1.1[${PYTHON_USEDEP}]
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5"

DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( app-doc/doxygen )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( README.md )

PATCHES=( "${FILESDIR}/${PN}-3.3.0-fix-install-paths.patch" )

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)" )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cmake-utils_src_compile doc
		DOCS+=( html )
	fi
}

src_test() {
	emake -C "${BUILD_DIR}" tests
}

src_install() {
	cmake-utils_src_install
	python_optimize "${D}usr/$(get_libdir)"
}
