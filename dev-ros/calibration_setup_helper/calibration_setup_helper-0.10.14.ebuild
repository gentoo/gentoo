# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Script to generate calibration launch and configurationfiles for your robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-ros/calibration_launch"
