# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/metapackages"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage for ROS perception stack"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	ros-meta/ros_base
	ros-meta/image_common
	ros-meta/image_pipeline
	ros-meta/image_transport_plugins
	ros-meta/laser_pipeline
	ros-meta/perception_pcl
	ros-meta/vision_opencv
"
DEPEND="${RDEPEND}"
