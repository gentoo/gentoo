# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/eigen_stl_containers"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Provides a set of typedef's that allow using Eigen datatypes in STL containers"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-cpp/eigen:3"
DEPEND="${RDEPEND}"
