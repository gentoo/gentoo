# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/console_bridge"
fi

inherit ${SCM} cmake

AMENT_LINT_VER=0.9.5
EXTERNAL_PROGS="
	https://raw.githubusercontent.com/ament/ament_lint/${AMENT_LINT_VER}/ament_cppcheck/ament_cppcheck/main.py -> ${P}-ament-${AMENT_LINT_VER}-cppcheck.py
	https://raw.githubusercontent.com/ament/ament_lint/${AMENT_LINT_VER}/ament_cpplint/ament_cpplint/cpplint.py -> ${P}-ament-${AMENT_LINT_VER}-cpplint.py
"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI="${EXTERNAL_PROGS}"
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="${EXTERNAL_PROGS}
		https://github.com/ros/console_bridge/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A ROS-independent package for logging into rosconsole/rosout"
HOMEPAGE="https://wiki.ros.org/console_bridge"
LICENSE="BSD"
SLOT="0/1"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-util/cppcheck
	)
"
PATCHES=( "${FILESDIR}/tests.patch" )

src_prepare() {
	# Avoid wgeting it. #733704
	sed -e 's/add_dependencies(console_bridge wget_cppchec/#/' -i test/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure

	# For tests
	if use test ; then
		cp "${DISTDIR}/${P}-ament-${AMENT_LINT_VER}-cppcheck.py" "${BUILD_DIR}/test/cppcheck.py" || die
		cp "${DISTDIR}/${P}-ament-${AMENT_LINT_VER}-cpplint.py" "${BUILD_DIR}/test/cpplint.py" || die
	fi
}

src_test() {
	export AMENT_CPPCHECK_ALLOW_1_88=yes
	cmake_src_test
}
