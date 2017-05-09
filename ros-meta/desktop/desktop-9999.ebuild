# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/metapackages"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage for a basic ROS desktop install"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	ros-meta/robot
	ros-meta/viz
	dev-ros/roslint
	ros-meta/visualization_tutorials
"
DEPEND="${RDEPEND}"
