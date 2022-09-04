# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-visualization/rviz"
KEYWORDS="~amd64"
CATKIN_HAS_MESSAGES=yes

CMAKE_MAKEFILE_GENERATOR=emake

inherit ros-catkin virtualx

DESCRIPTION="3D visualization tool for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	media-libs/assimp:=
	dev-games/ogre:=[-double-precision]
	virtual/opengl
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-cpp/eigen:3
	dev-cpp/yaml-cpp:=
	dev-libs/urdfdom:=
	dev-libs/tinyxml2:=

	dev-ros/angles:0
	dev-ros/image_geometry
	dev-ros/image_transport
	dev-ros/interactive_markers
	dev-ros/laser_geometry
	dev-ros/message_filters
	dev-ros/pluginlib
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_SINGLE_USEDEP}]
	dev-ros/resource_retriever
	dev-ros/rosconsole
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf
	dev-ros/urdf
	dev-ros/media_export

	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/map_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)"
BDEPEND="
	dev-ros/cmake_modules
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/yamlcpp.patch"
)

src_test() {
	virtx ros-catkin_src_test
}
