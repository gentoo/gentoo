# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/collada_urdf"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Convert Unified Robot Description Format (URDF) documents into COLLADA documents"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/angles
	dev-ros/collada_parser
	dev-ros/resource_retriever
	dev-ros/rosconsole
	dev-ros/urdf
	dev-ros/geometric_shapes
	media-libs/assimp
	dev-libs/collada-dom:=
	dev-cpp/eigen:3
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
"
