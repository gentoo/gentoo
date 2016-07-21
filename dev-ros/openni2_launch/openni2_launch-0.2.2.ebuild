# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/openni2_launch"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Launch files to start the openni2_camera drivers using rgbd_launch"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rgbd_launch
	dev-ros/depth_image_proc
	dev-ros/image_proc
	dev-ros/nodelet
	dev-ros/openni2_camera
	dev-ros/tf
"
DEPEND="${RDEPEND}"
