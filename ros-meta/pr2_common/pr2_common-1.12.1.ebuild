# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/pr2/pr2_common"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="URDF description and 3D models of robot components of the PR2 robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/pr2_msgs
	dev-ros/pr2_dashboard_aggregator
	dev-ros/pr2_description
	dev-ros/pr2_machine
"
DEPEND="${RDEPEND}"
