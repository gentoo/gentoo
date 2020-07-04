# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage of geometry tutorials ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/turtle_tf
	dev-ros/turtle_tf2
"
DEPEND="${RDEPEND}"
