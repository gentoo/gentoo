# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ccny-ros-pkg/imu_tools"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Various tools for IMU devices"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/imu_complementary_filter
	dev-ros/imu_filter_madgwick
	dev-ros/rviz_imu_plugin
"
DEPEND="${RDEPEND}"
