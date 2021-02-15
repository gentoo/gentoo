# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_7,3_8,3_9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rospkg"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Standalone Python library for the ROS package system"
HOMEPAGE="https://wiki.ros.org/rospkg"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	# Needed for tests
	S="${WORKDIR}/${PN}"
	EGIT_CHECKOUT_DIR="${S}"
else
	SRC_URI="https://github.com/ros-infrastructure/rospkg/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND} ${BDEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/gentoo.patch" "${FILESDIR}/yaml_load.patch" )

python_test() {
	nosetests --with-coverage --cover-package=rospkg --with-xunit test || die
}
