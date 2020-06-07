# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/RethinkRobotics-opensource/gennodejs"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Javascript ROS message and service generators"
HOMEPAGE="https://wiki.ros.org/gennodejs"
LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-ros/genmsg[${PYTHON_SINGLE_USEDEP}]"
DEPEND="${RDEPEND}"
