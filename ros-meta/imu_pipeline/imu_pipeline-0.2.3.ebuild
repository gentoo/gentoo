# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/imu_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tools for processing and pre-processing IMU messages for easier use by later subscribers"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/imu_processors
	dev-ros/imu_transformer
"
DEPEND="${RDEPEND}"
