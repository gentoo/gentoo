# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )
inherit cmake-utils python-single-r1

MY_PN=Uranium
MY_PV=${PV/_beta}

DESCRIPTION="A Python framework for building 3D printing related applications"
HOMEPAGE="https://github.com/Ultimaker/Uranium"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libarcus:*[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-qt/qtdeclarative:5
	dev-qt/qtquickcontrols:5"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( app-doc/doxygen )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
S="${WORKDIR}/${MY_PN}-${MY_PV}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
PATCHES=( "${FILESDIR}/uranium-2.1.0_beta-fix-install-paths.patch" )
DOCS=( README.md )

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
	enable_cmake-utils_src_install
	python_optimize "${D}usr/$(get_libdir)"
}
