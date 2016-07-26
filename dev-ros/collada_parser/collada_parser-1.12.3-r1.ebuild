# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/robot_model"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin flag-o-matic

DESCRIPTION="C++ parser for the Collada robot description format"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	>=dev-ros/urdf_parser_plugin-1.12.3-r1
	dev-ros/roscpp
	dev-ros/class_loader
	dev-libs/urdfdom_headers
	dev-libs/collada-dom
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/urdfdom1.patch" )

src_configure() {
	append-cxxflags -std=gnu++11
	ros-catkin_src_configure
}
