# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Rotates an image stream minimizing the angle between an arbitrary vector and the camera frame"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	media-libs/opencv:=
	dev-ros/dynamic_reconfigure
	dev-ros/eigen_conversions
	dev-ros/image_transport
	dev-ros/nodelet
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/tf2
	dev-ros/tf2_geometry_msgs
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
