# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
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
	dev-ros/angles:0
	dev-ros/collada_parser
	dev-ros/resource_retriever
	dev-ros/rosconsole
	dev-ros/urdf
	dev-ros/geometric_shapes
	media-libs/assimp:=
	dev-libs/collada-dom:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	dev-ros/cmake_modules
"
