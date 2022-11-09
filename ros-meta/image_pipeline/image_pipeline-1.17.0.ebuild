# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Fills the gap between raw images from a camera and higher-level processing"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/camera_calibration
	dev-ros/depth_image_proc
	dev-ros/image_proc
	dev-ros/image_publisher
	dev-ros/image_rotate
	dev-ros/image_view
	dev-ros/stereo_image_proc
"
DEPEND="${RDEPEND}"
