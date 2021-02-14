# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rosdep"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Command-line tool for installing ROS system dependencies"
HOMEPAGE="https://wiki.ros.org/rosdep"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/ros-infrastructure/rosdep/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-python/rosdistro[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/nose[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/tests.patch" )

python_test() {
	if has network-sandbox ${FEATURES}; then
		einfo "Skipping tests due to network sandbox"
	else
		env -u ROS_DISTRO nosetests --with-xunit test || die
	fi
}

pkg_postrm() {
	if [ "${ROOT:-/}" = "/" ] ; then
		einfo "Removing rosdep default sources list."
		rm -f "${EPREFIX}/etc/ros/rosdep/sources.list.d/20-default.list"
	fi
}

pkg_postinst() {
	if [ "${ROOT:-/}" = "/" -a ! -f "${EPREFIX}/etc/ros/rosdep/sources.list.d/20-default.list" ] ; then
		einfo "Initializing rosdep"
		rosdep init
	fi
}
