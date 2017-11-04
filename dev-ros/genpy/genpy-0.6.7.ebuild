# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/genpy"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

inherit ros-catkin

DESCRIPTION="Python ROS message and service generators"
HOMEPAGE="http://wiki.ros.org/genpy"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-ros/genmsg[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
