# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Listens on a ImageFeatures topic, and waits for the data to settle"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosconsole
	dev-ros/roscpp_serialization
	dev-ros/settlerlib
	dev-libs/boost:=[threads(+)]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
