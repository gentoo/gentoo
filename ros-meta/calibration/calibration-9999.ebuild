# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Provides a toolchain running through the robot calibration process"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/calibration_estimation
	dev-ros/calibration_launch
	dev-ros/calibration_msgs
	dev-ros/calibration_setup_helper
	dev-ros/image_cb_detector
	dev-ros/interval_intersection
	dev-ros/joint_states_settler
	dev-ros/laser_cb_detector
	dev-ros/monocam_settler
	dev-ros/settlerlib
"
DEPEND=""
