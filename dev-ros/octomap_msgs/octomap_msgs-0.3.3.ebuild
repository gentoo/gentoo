# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/OctoMap/octomap_msgs"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4} )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/geometry_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Messages and serializations / conversion for the OctoMap library"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
