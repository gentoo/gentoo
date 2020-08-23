# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Launch files for configuring the calibration stack to run on your robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	dev-ros/interval_intersection
	dev-ros/joint_states_settler
	dev-ros/laser_cb_detector
	dev-ros/monocam_settler
	dev-ros/roslaunch
	dev-libs/urdfdom
"
