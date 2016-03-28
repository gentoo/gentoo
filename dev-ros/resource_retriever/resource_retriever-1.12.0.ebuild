# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/resource_retriever"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Retrieves data from url-format files"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosconsole
	dev-ros/roslib
	net-misc/curl
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
