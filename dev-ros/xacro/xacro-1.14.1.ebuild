# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/xacro"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="XML macro language"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/roslint[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] )
"
RDEPEND="${RDEPEND}
	dev-ros/roslaunch[${PYTHON_USEDEP}]"
