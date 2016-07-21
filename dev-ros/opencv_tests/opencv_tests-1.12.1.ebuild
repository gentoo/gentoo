# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/vision_opencv"
KEYWORDS="~amd64 ~arm"
# Be careful: It needs opencv with python support but opencv is python-single-r1
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tests for ROS OpenCV integration"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	media-libs/opencv[python,python_single_target_python2_7]
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_install() {
	ros-catkin_src_install
	insinto /usr/share/${PN}/launch
	doins launch/*.launch
	exeinto /usr/libexec/${PN}
	doexe nodes/*
}
