# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/slam_gmapping"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS wrapper for OpenSlam's Gmapping"
LICENSE="CC-BY-NC-SA-2.5"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/gmapping"
DEPEND=""
