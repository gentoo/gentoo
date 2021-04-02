# Copyright 1999-2021 Gentoo Authors
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
	dev-ros/diagnostic_updater[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep "dev-python/psutil[\${PYTHON_USEDEP}]")
	app-admin/hddtemp"
DEPEND="${DEPEND}
	test? (
		$(python_gen_cond_dep "dev-python/psutil[\${PYTHON_USEDEP}]")
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	)
"
