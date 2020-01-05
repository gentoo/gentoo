# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit cmake-utils python-single-r1

MY_PN="libCharon"

DESCRIPTION="This library facilitates communication between Cura and its backend"
HOMEPAGE="https://github.com/Ultimaker/libCharon"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# Use current python version, not the latest installed
	sed -i "s/find_package(Python3 3.4 REQUIRED/find_package(Python3 ${EPYTHON##python} EXACT REQUIRED/g" CMakeLists.txt || die

	cmake-utils_src_prepare
}
