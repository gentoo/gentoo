# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/robot_model"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="C++ parser for the Collada robot description format"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	>=dev-ros/urdf_parser_plugin-1.12.6
	dev-ros/roscpp
	dev-ros/class_loader
	dev-libs/urdfdom_headers
	dev-libs/collada-dom
	>=dev-ros/urdf-1.12.6
"
DEPEND="${RDEPEND}"
