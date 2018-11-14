# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/control_toolbox"
KEYWORDS="~amd64"
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"
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
	dev-libs/boost:=[threads]
	dev-libs/tinyxml
	dev-ros/control_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
