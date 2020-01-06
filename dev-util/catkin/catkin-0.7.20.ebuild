# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/catkin"
fi

PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit ${SCM} cmake-utils python-r1

DESCRIPTION="Cmake macros and associated python code used to build some parts of ROS"
HOMEPAGE="http://wiki.ros.org/catkin"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/ros/catkin/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/empy[${PYTHON_USEDEP}]
	dev-util/cmake
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] dev-python/mock[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/tests.patch"
	"${FILESDIR}/distutils.patch"
	"${FILESDIR}/catkin_prefix_path.patch"
	"${FILESDIR}/gnuinstalldirs.patch"
	"${FILESDIR}/catkin_prefix_path_util_py_v2.patch"
	"${FILESDIR}/package_xml.patch"
	"${FILESDIR}/etc.patch"
	"${FILESDIR}/sitedir.patch"
)

src_prepare() {
	# fix libdir
	sed -i \
		-e 's:LIBEXEC_DESTINATION lib:LIBEXEC_DESTINATION libexec:' \
		-e 's:}/lib:}/${CMAKE_INSTALL_LIBDIR}:' \
		-e 's:DESTINATION lib):DESTINATION ${CMAKE_INSTALL_LIBDIR}):' \
		-e 's:DESTINATION lib/:DESTINATION ${CMAKE_INSTALL_LIBDIR}/:' \
		-e 's:PYTHON_INSTALL_DIR lib:PYTHON_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}:' \
		cmake/*.cmake || die
	cmake-utils_src_prepare
}

catkin_src_configure_internal() {
	local sitedir="$(python_get_sitedir)"
	mycmakeargs+=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INSTALL_DIR="${sitedir#${EPREFIX}/usr/}"
	)
	python_export PYTHON_SCRIPTDIR
	cmake-utils_src_configure
}

src_configure() {
	export PYTHONPATH="${S}/python"
	local mycmakeargs=(
		"$(cmake-utils_use test CATKIN_ENABLE_TESTING)"
		"-DCATKIN_BUILD_BINARY_PACKAGE=ON"
		)
	python_foreach_impl catkin_src_configure_internal
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	unset PYTHON_SCRIPTDIR
	python_foreach_impl cmake-utils_src_test
}

catkin_src_install_internal() {
	python_export PYTHON_SCRIPTDIR
	cmake-utils_src_install
	if [ ! -f "${T}/.catkin_python_symlinks_generated" ]; then
		dodir /usr/bin
		for i in "${D}/${PYTHON_SCRIPTDIR}"/* ; do
			dosym ../lib/python-exec/python-exec2 "/usr/bin/${i##*/}" || die
		done
		touch "${T}/.catkin_python_symlinks_generated"
	fi
}

src_install() {
	python_foreach_impl catkin_src_install_internal

	doenvd "${FILESDIR}/40catkin"

	# needed to be considered as a workspace
	touch "${ED}/usr/.catkin"
}

pkg_postinst() {
	ewarn "Starting from version 0.7.1-r2, dev-util/catkin changed the"
	ewarn "installation path for package.xml files on Gentoo."
	ewarn "In order for ROS to work properly, you will need to reinstall ROS"
	ewarn "packages that have it installed in the old location:"
	ewarn "		emerge -1O /usr/share/*/package.xml"
	ewarn "See https://bugs.gentoo.org/show_bug.cgi?id=595004 for more details."
}
