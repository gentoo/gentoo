# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="2D navigation stack"
LICENSE="BSD LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/amcl
	dev-ros/base_local_planner
	dev-ros/carrot_planner
	dev-ros/clear_costmap_recovery
	dev-ros/costmap_2d
	dev-ros/dwa_local_planner
	dev-ros/fake_localization
	dev-ros/global_planner
	dev-ros/map_server
	dev-ros/move_base
	dev-ros/move_slow_and_clear
	dev-ros/nav_core
	dev-ros/navfn
	dev-ros/robot_pose_ekf
	dev-ros/rotate_recovery
	dev-ros/voxel_grid
"
DEPEND="${RDEPEND}"
