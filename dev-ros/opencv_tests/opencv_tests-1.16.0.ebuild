# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/vision_opencv"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tests for ROS OpenCV integration"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "media-libs/opencv[python,\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/numpy[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}"

src_install() {
	ros-catkin_src_install
	insinto /usr/share/${PN}/launch
	doins launch/*.launch
	exeinto /usr/libexec/${PN}
	doexe nodes/*
}
