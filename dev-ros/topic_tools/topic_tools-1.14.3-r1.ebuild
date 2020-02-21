# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=tools/${PN}
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Tools for directing, throttling and selecting ROS topics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cpp_common
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rostime
	dev-ros/xmlrpcpp
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-ros/rosunit[${PYTHON_USEDEP}]
		dev-cpp/gtest
		dev-python/nose[${PYTHON_USEDEP}]
	)"
PATCHES=( "${FILESDIR}/yaml.patch" )
