# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rosdep"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Command-line tool for installing ROS system dependencies"
HOMEPAGE="http://wiki.ros.org/rosdep"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/ros-infrastructure/rosdep/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-python/rosdistro[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/nose[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)
"

python_test() {
	nosetests --with-coverage --cover-package=rosdep2 --with-xunit test || die
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
