# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Generic nodes for monitoring a linux host"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	dev-ros/diagnostic_updater[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/tf[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	app-admin/hddtemp"
