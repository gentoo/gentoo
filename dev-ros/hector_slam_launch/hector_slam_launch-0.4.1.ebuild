# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Launch files for launching hector_slam with different robot scenarios"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	dev-ros/hector_mapping
	dev-ros/hector_map_server
	dev-ros/hector_trajectory_server
	dev-ros/hector_geotiff
	dev-ros/hector_geotiff_plugins
"
