# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/geometry_msgs dev-ros/sensor_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Messages for storing calibration samples to be used in calibration procedures"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
