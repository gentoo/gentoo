# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Routines for reading and writing camera calibration parameters"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
	dev-ros/rosconsole
	>=dev-cpp/yaml-cpp-0.5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/nose )
"
