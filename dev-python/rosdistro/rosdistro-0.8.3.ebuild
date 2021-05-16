# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_7,3_8,3_9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rosdistro"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Tools to work with catkinized rosdistro files"
HOMEPAGE="https://wiki.ros.org/rosdistro"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/ros-infrastructure/rosdistro/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/yaml.patch" )

src_prepare() {
	# Requires network access
	rm -f test/test_manifest_providers.py
	default
}

python_test() {
	nosetests --with-xunit test || die
}
