# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Common geometric calculations"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/eigen_conversions
	dev-ros/kdl_conversions
	dev-ros/tf
	dev-ros/tf_conversions
"
DEPEND="${RDEPEND}"
