# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/rviz"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="3D visualization tool for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	media-libs/assimp
	<dev-games/ogre-1.10:=
	virtual/opengl
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-cpp/eigen:3
	dev-cpp/yaml-cpp:=
	dev-libs/urdfdom:=
	dev-libs/tinyxml2:=

	dev-ros/angles
	dev-ros/image_geometry
	dev-ros/image_transport
	dev-ros/interactive_markers
	dev-ros/laser_geometry
	dev-ros/message_filters
	dev-ros/pluginlib
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_USEDEP}]
	dev-ros/resource_retriever
	dev-ros/rosbag[${PYTHON_USEDEP}]
	dev-ros/rosconsole
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/tf
	dev-ros/urdf
	dev-ros/media_export

	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/map_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	virtual/pkgconfig
	test? (
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-cpp/gtest
	)"

src_configure() {
	local mycatkincmakeargs=( "-DUseQt5=ON" )
	ros-catkin_src_configure
}
