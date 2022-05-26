# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Standalone Python library for the ROS package system"
HOMEPAGE="https://wiki.ros.org/rospkg"

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rospkg"
	inherit git-r3

	S="${WORKDIR}/${PN}"
	EGIT_CHECKOUT_DIR="${S}"
else
	SRC_URI="https://github.com/ros-infrastructure/rospkg/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/gentoo.patch"
)

distutils_enable_tests pytest
