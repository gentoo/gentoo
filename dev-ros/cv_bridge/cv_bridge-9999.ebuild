# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/vision_opencv"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Converts between ROS Image messages and OpenCV images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosconsole
	>=media-libs/opencv-3:=[contrib(+),png,jpeg,tiff]
	$(python_gen_cond_dep "dev-libs/boost:=[python,\${PYTHON_USEDEP}]")
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-cpp/gtest
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/boostpython.patch" "${FILESDIR}/ocv_leak.patch" )
