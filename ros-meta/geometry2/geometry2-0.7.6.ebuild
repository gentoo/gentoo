# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="The second generation Transform Library in ros"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/test_tf2
	dev-ros/tf2
	dev-ros/tf2_bullet
	dev-ros/tf2_eigen
	dev-ros/tf2_geometry_msgs
	dev-ros/tf2_kdl
	dev-ros/tf2_msgs
	dev-ros/tf2_py
	dev-ros/tf2_ros
	dev-ros/tf2_sensor_msgs
	dev-ros/tf2_tools
"
DEPEND="${RDEPEND}"
