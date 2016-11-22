# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/RethinkRobotics-opensource/gennodejs"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit ros-catkin

DESCRIPTION="Javascript ROS message and service generators"
HOMEPAGE="http://wiki.ros.org/genpy"
LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-ros/genmsg[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
