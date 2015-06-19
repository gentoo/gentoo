# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/urdfdom_headers/urdfdom_headers-9999.ebuild,v 1.1 2015/04/14 12:27:17 aballier Exp $

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/urdfdom_headers"
fi

inherit ${SCM} cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
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
