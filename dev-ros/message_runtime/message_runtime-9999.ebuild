# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/message_runtime"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Package modeling the run-time dependencies for language bindings of messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	dev-ros/cpp_common
	dev-ros/rostime
	dev-ros/roscpp_traits
	dev-ros/roscpp_serialization"
