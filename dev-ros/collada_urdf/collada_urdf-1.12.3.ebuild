# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/robot_model"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tool to convert Unified Robot Description Format (URDF) documents into COLLADA documents"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/angles
	dev-ros/collada_parser
	dev-ros/resource_retriever
	dev-ros/urdf
	dev-ros/geometric_shapes
	dev-ros/tf
	media-libs/assimp
	dev-libs/tinyxml
	dev-libs/collada-dom
"
DEPEND="${RDEPEND}"
