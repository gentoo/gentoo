# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/perception_pcl"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="PCL (Point Cloud Library) ROS interface stack"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/pcl_conversions
	dev-ros/pcl_ros
"
DEPEND="${RDEPEND}"
