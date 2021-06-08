# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-drivers/driver_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Classes and tools that are useful throughout the driver stacks"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/driver_base
	dev-ros/timestamp_tools
"
DEPEND="${RDEPEND}"
