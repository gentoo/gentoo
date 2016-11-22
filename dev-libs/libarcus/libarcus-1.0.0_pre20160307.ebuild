# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python3_4 python3_5 )
inherit cmake-utils python-single-r1

MY_PN="libArcus"
COMMIT="1db8a8e57dbf0d68d9e9f85ef9022b8eae17c9ec"

DESCRIPTION="This library facilitates communication between Cura and its backend"
HOMEPAGE="https://github.com/Ultimaker/libArcus"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0/2"
IUSE="examples python static-libs"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	dev-python/sip[${PYTHON_USEDEP}]
	>=dev-libs/protobuf-3:=
	>=dev-python/protobuf-python-3:*[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_PN}-${COMMIT}"
PATCHES=( "${FILESDIR}/${PN}-1.0.0-fix-install-paths.patch" )
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_EXAMPLES=$(usex examples ON OFF)
		-DBUILD_STATIC=$(usex static-libs ON OFF)
	)
	use python && mycmakeargs+=( -DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)" )
	cmake-utils_src_configure
}
