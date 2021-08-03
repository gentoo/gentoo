# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Launch files for the hector_geotiff mapper"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/hector_geotiff
	dev-ros/hector_geotiff_plugins
	dev-ros/hector_trajectory_server
"
DEPEND=""
