# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rospkg"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Standalone Python library for the ROS package system"
HOMEPAGE="http://wiki.ros.org/rospkg"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
	# Needed for tests
	S="${WORKDIR}/${PN}"
	EGIT_CHECKOUT_DIR="${S}"
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/ros-infrastructure/rospkg/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/norecurse.patch"
)

python_test() {
	nosetests --with-coverage --cover-package=rospkg --with-xunit test || die
}

src_install() {
	distutils-r1_src_install

	# Avoid recursing into /usr/share when looking for packages.
	dodir /usr/share
	touch "${ED}/usr/share/rospack_norecurse"
}
