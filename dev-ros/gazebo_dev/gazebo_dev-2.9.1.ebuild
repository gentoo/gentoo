# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Cmake config for the default version of Gazebo for the ROS distribution"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	sci-electronics/gazebo
"
DEPEND="${RDEPEND}"
