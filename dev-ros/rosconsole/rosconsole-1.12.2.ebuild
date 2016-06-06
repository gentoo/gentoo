# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="ROS console output library"
LICENSE="BSD"
SLOT="0"
IUSE="+log4cxx glog"

RDEPEND="
	dev-ros/cpp_common
	dev-ros/rostime
	dev-ros/rosunit
	dev-libs/boost:=[threads]
	log4cxx? ( dev-libs/log4cxx )
	!log4cxx? ( glog? ( dev-cpp/glog ) )
"
DEPEND="${RDEPEND}"

src_configure() {
	local ROSCONSOLE_BACKEND=""
	if use log4cxx; then
		ROSCONSOLE_BACKEND="log4cxx"
	elif use glog; then
		ROSCONSOLE_BACKEND="glog"
	else
		ROSCONSOLE_BACKEND="print"
	fi
	local mycatkincmakeargs=( "-DROSCONSOLE_BACKEND=${ROSCONSOLE_BACKEND}" )
	ros-catkin_src_configure
}
