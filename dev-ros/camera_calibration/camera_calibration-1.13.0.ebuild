# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Calibration of monocular or stereo cameras using a checkerboard calibration target"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge[${PYTHON_USEDEP}]
	dev-ros/image_geometry[${PYTHON_USEDEP}]
	|| ( media-libs/opencv[python,${PYTHON_USEDEP}] media-libs/opencv[python,python_single_target_python2_7] )
	dev-ros/message_filters[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/std_srvs[${PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
