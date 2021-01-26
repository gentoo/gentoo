# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

ROS_PN="ament_lint"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ament/ament_lint"
	SRC_URI=""
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/ament/ament_lint/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
fi

DESCRIPTION="Common API for ament linter packages"
HOMEPAGE="https://github.com/ament/ament_lint"

LICENSE="Apache-2.0"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""
