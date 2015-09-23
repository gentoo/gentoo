# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/control_toolbox"
KEYWORDS="~amd64"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Modules that are useful across all controllers"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/dynamic_reconfigure
	dev-ros/realtime_tools
	dev-ros/std_msgs
	dev-libs/boost:=[threads]
	dev-libs/tinyxml
"
DEPEND="${RDEPEND}"
