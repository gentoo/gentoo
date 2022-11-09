# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs dev-ros/map_msgs"

inherit ros-catkin

DESCRIPTION="Creates a 2D costmap from sensor data"
LICENSE="BSD"
SLOT="0"
IUSE=""
REQUIRED_USE="ros_messages_cxx"
DATA="simple_driving_test_indexed.bag willow-full-0.025.pgm"
for i in ${DATA}; do
	SRC_URI="${SRC_URI}
		http://download.ros.org/data/costmap_2d/${i} -> ${P}-${i}"
done

RDEPEND="
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/laser_geometry
	dev-ros/message_filters
	>=dev-ros/pluginlib-1.13.0-r1
	dev-ros/roscpp
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-ros/voxel_grid

	dev-libs/boost:=
	dev-libs/tinyxml2:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_sensor_msgs
	test? (
		dev-ros/map_server
		dev-ros/rosbag
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
		dev-ros/rosunit
	)"
BDEPEND="
	dev-ros/cmake_modules
"

src_prepare() {
	ros-catkin_src_prepare
	for i in ${DATA}; do
		cp "${DISTDIR}/${P}-${i}" "${S}/${i}" || die
	done
	sed -e "s#http://download.ros.org/data/costmap_2d/#file://${S}/#" -i CMakeLists.txt || die
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	export CATKIN_PREFIX_PATH="${BUILD_DIR}/devel/:${CATKIN_PREFIX_PATH}"
	ros-catkin_src_test
}
