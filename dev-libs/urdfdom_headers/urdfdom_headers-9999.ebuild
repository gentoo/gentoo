# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/urdfdom_headers"
fi

inherit ${SCM} cmake

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/ros/urdfdom_headers/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="URDF (U-Robot Description Format) headers"
HOMEPAGE="http://ros.org/wiki/urdf"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
