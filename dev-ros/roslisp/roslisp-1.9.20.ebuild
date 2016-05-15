# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/roslisp"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="Lisp client library for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roslang
	dev-lisp/sbcl
	dev-ros/rospack
	dev-ros/rosgraph_msgs
	dev-ros/std_srvs
"
DEPEND="${RDEPEND}"
