# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils python-any-r1

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ros2/console_bridge_vendor"
	SRC_URI=""
else
	SRC_URI="https://github.com/ros2/console_bridge_vendor/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Wrapper around console_bridge"
HOMEPAGE="https://github.com/ros2/console_bridge_vendor"

LICENSE="Apache-2.0 BSD"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

DEPEND="
	>=dev-libs/console_bridge-0.4.1
"
RDEPEND="${DEPEND}"
BDEPEND="
	$(python_gen_any_dep 'ros-meta/ament_cmake[${PYTHON_USEDEP}]')
	${PYTHON_DEPS}
"
