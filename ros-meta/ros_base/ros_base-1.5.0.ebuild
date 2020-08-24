# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/metapackages"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage which extends ros_core and includes other basic non-robot tools"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib
	ros-meta/bond_core
	dev-ros/dynamic_reconfigure
	ros-meta/nodelet_core
"
DEPEND="${RDEPEND}"
