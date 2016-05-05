# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/convex_decomposition"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="Convex Decomposition Tool for Robot Model"
LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="app-arch/unzip"
DEPEND="${RDEPEND}"
