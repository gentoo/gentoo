# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit cmake-utils python-single-r1

MY_PN="libSavitar"

DESCRIPTION="C++ implementation of 3mf loading with SIP python bindings"
HOMEPAGE="https://github.com/Ultimaker/libSavitar"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="+python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="${PYTHON_DEPS}
	dev-libs/pugixml
	dev-python/sip[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-4.2.0-remove-packaged-pugixml.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Find SIP for current python version, not the latest installed
	sed -i "s/find_package(Python3 3.4 REQUIRED/find_package(Python3 ${EPYTHON##python} EXACT REQUIRED/g" CMakeLists.txt || die
	sed -i "s/find_package(Python3 3.4 REQUIRED/find_package(Python3 ${EPYTHON##python} EXACT REQUIRED/g" cmake/FindSIP.cmake || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_STATIC=$(usex static-libs ON OFF)
	)

	cmake-utils_src_configure
}
