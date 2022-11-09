# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Calibration of monocular or stereo cameras"
LICENSE="BSD"
SLOT="0"
IUSE=""
SRC_URI="${SRC_URI}
	http://download.ros.org/data/camera_calibration/camera_calibration.tar.gz -> ${P}-camera_calibration.tar.gz
	http://download.ros.org/data/camera_calibration/multi_board_calibration.tar.gz -> ${P}-multi_board_calibration.tar.gz
"

RDEPEND="
	dev-ros/cv_bridge[${PYTHON_SINGLE_USEDEP}]
	dev-ros/image_geometry[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "media-libs/opencv[python,\${PYTHON_USEDEP}]")
	dev-ros/message_filters[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/std_srvs[${PYTHON_SINGLE_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	)"

src_prepare() {
	ros-catkin_src_prepare
	# Avoid external downloads during tests
	cp "${DISTDIR}/${P}-camera_calibration.tar.gz" "${S}/camera_calibration.tar.gz" || die
	cp "${DISTDIR}/${P}-multi_board_calibration.tar.gz" "${S}/multi_board_calibration.tar.gz" || die
	sed -e "s#http://download.ros.org/data/camera_calibration/#file://${S}/#" -i CMakeLists.txt || die
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
