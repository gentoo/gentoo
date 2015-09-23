# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/vision_opencv"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Converts between ROS Image messages and OpenCV images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	dev-ros/image_geometry
	dev-ros/opencv_tests
"
DEPEND="${RDEPEND}"
