# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-geographic-info/unique_identifier"
VER_PREFIX=unique_identifier-
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS messages and interfaces for universally unique identifiers"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/unique_id
	dev-ros/uuid_msgs
"
DEPEND="${RDEPEND}"
