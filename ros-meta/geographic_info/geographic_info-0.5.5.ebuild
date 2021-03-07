# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-geographic-info/geographic_info"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Geographic information metapackage"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geodesy
	dev-ros/geographic_msgs
"
DEPEND="${RDEPEND}"
