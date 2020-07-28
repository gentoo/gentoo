# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/laser_pipeline"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Meta-package for processing laser data"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/laser_assembler
	dev-ros/laser_filters
	dev-ros/laser_geometry
"
DEPEND="${RDEPEND}"
