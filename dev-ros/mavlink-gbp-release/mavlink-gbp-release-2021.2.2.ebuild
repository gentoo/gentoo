# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/mavlink/mavlink-gbp-release"
EGIT_BRANCH="release/noetic/mavlink"
VER_PREFIX="${EGIT_BRANCH}/"
VER_SUFFIX=-${PV#*_p}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="MAVLink message marshaling library"
LICENSE="LGPL-3"
SLOT="0"
IUSE=""

RDEPEND="$(python_gen_cond_dep "dev-python/future[\${PYTHON_USEDEP}]")"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${EGIT_BRANCH//\//-}"
PATCHES=( "${FILESDIR}/gentoo.patch" )
