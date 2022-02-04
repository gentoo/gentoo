# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

ROS_PN="ament_lint"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ament/ament_lint"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/ament/ament_lint/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Checks XML files like the package manifest using xmllint"
HOMEPAGE="https://github.com/ament/ament_lint"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-ros/ament_lint[${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-ros/ament_copyright[${PYTHON_USEDEP}]
		dev-ros/ament_flake8[${PYTHON_USEDEP}]
		dev-ros/ament_pep257[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
