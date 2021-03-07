# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/rosbag_migration_rule"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Allows to export rosbag migration rule files without depending on rosbag"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
