# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="hector_mapping and related packages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/hector_compressed_map_transport
	dev-ros/hector_geotiff_plugins
	dev-ros/hector_imu_tools
	dev-ros/hector_map_server
	dev-ros/hector_marker_drawing
	dev-ros/hector_trajectory_server
	dev-ros/hector_geotiff
	dev-ros/hector_imu_attitude_to_tf
	dev-ros/hector_mapping
	dev-ros/hector_map_tools
	dev-ros/hector_nav_msgs
	dev-ros/hector_slam_launch
"
DEPEND=""
