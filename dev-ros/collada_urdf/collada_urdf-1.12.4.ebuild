# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/robot_model"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin flag-o-matic

DESCRIPTION="Tool to convert Unified Robot Description Format (URDF) documents into COLLADA documents"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/angles
	dev-ros/collada_parser
	dev-ros/resource_retriever
	>=dev-ros/urdf-1.12.3-r1
	dev-ros/geometric_shapes
	dev-ros/tf
	media-libs/assimp
	dev-libs/tinyxml
	dev-libs/collada-dom
	>=dev-libs/urdfdom-1:=
	dev-cpp/eigen:3
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/urdfdom1.patch" )

src_configure() {
	append-cppflags `pkg-config --cflags eigen3`
	append-cxxflags -std=gnu++11
	ros-catkin_src_configure
}
