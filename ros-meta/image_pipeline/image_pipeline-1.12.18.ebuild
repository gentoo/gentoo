# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Fills the gap between getting raw images from a camera driver and higher-level vision processing"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/camera_calibration
	dev-ros/depth_image_proc
	dev-ros/image_proc
	dev-ros/image_rotate
	dev-ros/image_view
	dev-ros/stereo_image_proc
"
DEPEND="${RDEPEND}"
