# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros-geographic-info/geographic_info"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/geometry_msgs dev-ros/std_msgs dev-ros/uuid_msgs"

inherit ros-catkin

DESCRIPTION="ROS messages for Geographic Information Systems"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
