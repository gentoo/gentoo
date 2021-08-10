# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/openslam_gmapping"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="ROS-ified version of gmapping SLAM"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
