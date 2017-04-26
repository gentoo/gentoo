# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Robot self-test node"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_msgs
	dev-ros/diagnostic_updater
	dev-ros/roscpp
	dev-ros/rostest
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest )"
