# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/cra-ros-pkg/robot_localization"
KEYWORDS="~amd64"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geographic_msgs dev-ros/geometry_msgs"

inherit ros-catkin

DESCRIPTION="Package of nonlinear state estimation nodes"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_updater
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/eigen_conversions
	dev-ros/geographic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/message_filters
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_geometry_msgs
	dev-ros/tf2_ros
	dev-ros/xmlrpcpp
	dev-libs/boost:=
	dev-cpp/yaml-cpp:=
	dev-ros/nodelet
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/roslint
	dev-cpp/eigen:3
	test? ( dev-ros/rosbag dev-ros/rostest dev-ros/rosunit )
"

PATCHES=( "${FILESDIR}/nowerror.patch" )
