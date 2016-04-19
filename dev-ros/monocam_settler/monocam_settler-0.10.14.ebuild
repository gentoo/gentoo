# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Listens on a ImageFeatures topic, and waits for the data to settle"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib[${PYTHON_USEDEP}]
	dev-ros/rosconsole
	dev-ros/roscpp_serialization
	dev-ros/settlerlib
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
