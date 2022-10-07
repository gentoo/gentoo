# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/nav_msgs dev-ros/visualization_msgs"

inherit ros-catkin

DESCRIPTION="SLAM that can be used without odometry and on platforms that exhibit roll/pitch"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/message_filters
	dev-ros/laser_geometry
	dev-ros/tf_conversions
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3"
