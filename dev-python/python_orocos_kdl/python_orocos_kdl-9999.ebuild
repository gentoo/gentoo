# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit python-r1 cmake

DESCRIPTION="Python bindings for KDL"
HOMEPAGE="https://www.orocos.org/kdl.html"
if [[ ${PV} = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/orocos/orocos_kinematics_dynamics"
	S="${WORKDIR}/${P}/python_orocos_kdl"
else
	SRC_URI="https://github.com/orocos/orocos_kinematics_dynamics/archive/v${PV}.tar.gz -> orocos_kinematics_dynamics-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm"
	S="${WORKDIR}/orocos_kinematics_dynamics-${PV}/python_orocos_kdl"
fi

# pybind11 strips targets at build otherwise...
# https://bugs.gentoo.org/806857
CMAKE_BUILD_TYPE=RelWithDebInfo

LICENSE="LGPL-2.1"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=sci-libs/orocos_kdl-1.4.0:=
	dev-python/pybind11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e 's/find_package(catkin/find_package(NoTcatkin/' \
		-e 's/add_subdirectory(pybind11/find_package(pybind11/' \
		-e 's/dist-packages/site-packages/' \
		-i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	python_foreach_impl cmake_src_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	python_foreach_impl cmake_src_test
}

src_install() {
	python_foreach_impl cmake_src_install
}
