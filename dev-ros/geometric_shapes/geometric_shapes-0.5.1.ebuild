# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/geometric_shapes"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Generic definitions of geometric shapes and bodies"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	media-libs/qhull
	media-libs/assimp
	sci-libs/octomap
	dev-ros/random_numbers
	dev-ros/resource_retriever
	dev-ros/eigen_stl_containers
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/shape_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest dev-ros/rosunit )
"
