# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/resource_retriever"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Retrieves data from url-format files"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosconsole
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	net-misc/curl
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	if has network-sandbox ${FEATURES}; then
		einfo "Skipping network tests due to network sandbox"
		export GTEST_FILTER='-Retriever.http'
		export NOSE_TESTMATCH='^(?!test_http).*'
	fi
	ros-catkin_src_test
}
