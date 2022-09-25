# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/RobotWebTools/rosbridge_suite"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="A WebSocket interface to rosbridge"
LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-ros/rosbridge_library[${PYTHON_SINGLE_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosbridge_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosapi[${PYTHON_SINGLE_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosauth[${PYTHON_SINGLE_USEDEP}]

	$(python_gen_cond_dep '
		dev-python/autobahn[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
	')
	"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_SINGLE_USEDEP}] )
"
