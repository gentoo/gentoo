# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/OctoMap/octomap_ros"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Conversion functions between ROS / PCL and OctoMap's native types"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf
	dev-ros/pcl_ros
	dev-ros/octomap_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
