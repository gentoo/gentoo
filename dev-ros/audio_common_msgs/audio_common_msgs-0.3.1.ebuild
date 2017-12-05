# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/audio_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

inherit ros-catkin

DESCRIPTION="Messages for transmitting audio via ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
