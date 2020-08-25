# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Script to generate calibration launch and configurationfiles for your robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-ros/calibration_launch"
