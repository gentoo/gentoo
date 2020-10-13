# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/geometric_shapes"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Generic definitions of geometric shapes and bodies"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	media-libs/qhull
	media-libs/assimp
	sci-libs/octomap
	dev-ros/random_numbers
	dev-ros/resource_retriever
	dev-ros/eigen_stl_containers
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/shape_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-cpp/gtest dev-ros/rosunit )
"

src_prepare() {
	ros-catkin_src_prepare
	# https://bugs.gentoo.org/738556
	# http://eigen.tuxfamily.org/dox-devel/group__TopicUnalignedArrayAssert.html
	append-cxxflags '-std=c++17'
	sed -e 's/add_compile_options(/#\0/g' -i CMakeLists.txt || die
}
