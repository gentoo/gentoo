# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ros-catkin.eclass
# @MAINTAINER:
# ros@gentoo.org
# @AUTHOR:
# Alexis Ballier <aballier@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: Template eclass for catkin based ROS packages.
# @DESCRIPTION:
# Provides function for building ROS packages on Gentoo.
# It supports selectively building messages, single-python installation, live ebuilds (git only).

# @ECLASS-VARIABLE: CMAKE_ECLASS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to "cmake-utils" for EAPI 5 and 6, "cmake" for EAPI-7.

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "EAPI='${EAPI}' is not supported"
		;;
	[56])
		CMAKE_ECLASS=cmake-utils
		;;
	*)
		CMAKE_ECLASS=cmake
		;;
esac

# @ECLASS-VARIABLE: ROS_REPO_URI
# @DESCRIPTION:
# URL of the upstream repository. Usually on github.
# Serves for fetching tarballs, live ebuilds and inferring the meta-package name.
EGIT_REPO_URI="${ROS_REPO_URI}"

# @ECLASS-VARIABLE: ROS_SUBDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Subdir in which current packages is located.
# Usually, a repository contains several packages, hence a typical value is:
# ROS_SUBDIR=${PN}

# @ECLASS-VARIABLE: CATKIN_IN_SOURCE_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to enable in-source build.

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
fi

# ROS only really works with one global python version and the target
# version depends on the release. Noetic targets 3.7 and 3.8.
# py3.8 or later are ok to add there as long as dev-ros/* have their deps satisfied.
PYTHON_COMPAT=( python3_7 )

inherit ${SCM} python-single-r1 ${CMAKE_ECLASS} flag-o-matic

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep "dev-util/catkin[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/empy[\${PYTHON_USEDEP}]")
"

# @ECLASS-VARIABLE: CATKIN_HAS_MESSAGES
# @DESCRIPTION:
# Set it to a non-empty value before inherit to tell the eclass the package has messages to build.
# Messages will be built based on ROS_MESSAGES USE_EXPANDed variable.

# @ECLASS-VARIABLE: CATKIN_MESSAGES_TRANSITIVE_DEPS
# @DESCRIPTION:
# Some messages have dependencies on other messages.
# In that case, CATKIN_MESSAGES_TRANSITIVE_DEPS should contain a space-separated list of atoms
# representing those dependencies. The eclass uses it to ensure proper dependencies on these packages.
if [ -n "${CATKIN_HAS_MESSAGES}" ] ; then
	IUSE="${IUSE} +ros_messages_python +ros_messages_cxx ros_messages_eus ros_messages_lisp ros_messages_nodejs"
	RDEPEND="${RDEPEND}
		ros_messages_cxx?    ( dev-ros/gencpp:=[${PYTHON_SINGLE_USEDEP}]    )
		ros_messages_eus?    ( dev-ros/geneus:=[${PYTHON_SINGLE_USEDEP}]    )
		ros_messages_python? ( dev-ros/genpy:=[${PYTHON_SINGLE_USEDEP}]     )
		ros_messages_lisp?   ( dev-ros/genlisp:=[${PYTHON_SINGLE_USEDEP}]   )
		ros_messages_nodejs? ( dev-ros/gennodejs:=[${PYTHON_SINGLE_USEDEP}] )
		dev-ros/message_runtime
	"
	DEPEND="${DEPEND} ${RDEPEND}
		dev-ros/message_generation
		dev-ros/genmsg[${PYTHON_SINGLE_USEDEP}]
	"
	if [ -n "${CATKIN_MESSAGES_TRANSITIVE_DEPS}" ] ; then
		for i in ${CATKIN_MESSAGES_TRANSITIVE_DEPS} ; do
			ds="${i}[ros_messages_python(-)?,ros_messages_cxx(-)?,ros_messages_lisp(-)?,ros_messages_eus(-)?,ros_messages_nodejs(-)?] ros_messages_python? ( ${i}[${PYTHON_SINGLE_USEDEP}] )"
			RDEPEND="${RDEPEND} ${ds}"
			DEPEND="${DEPEND} ${ds}"
		done
	fi
fi

# @ECLASS-VARIABLE: CATKIN_MESSAGES_CXX_USEDEP
# @DESCRIPTION:
# Use it as cat/pkg[${CATKIN_MESSAGES_CXX_USEDEP}] to indicate a dependency on the C++ messages of cat/pkg.
CATKIN_MESSAGES_CXX_USEDEP="ros_messages_cxx(-)"

# @ECLASS-VARIABLE: CATKIN_MESSAGES_PYTHON_USEDEP
# @DESCRIPTION:
# Use it as cat/pkg[${CATKIN_MESSAGES_PYTHON_USEDEP}] to indicate a dependency on the Python messages of cat/pkg.
CATKIN_MESSAGES_PYTHON_USEDEP="ros_messages_python(-),${PYTHON_SINGLE_USEDEP}"

# @ECLASS-VARIABLE: CATKIN_MESSAGES_LISP_USEDEP
# @DESCRIPTION:
# Use it as cat/pkg[${CATKIN_MESSAGES_LISP_USEDEP}] to indicate a dependency on the Common-Lisp messages of cat/pkg.
CATKIN_MESSAGES_LISP_USEDEP="ros_messages_lisp(-)"

# @ECLASS-VARIABLE: CATKIN_MESSAGES_EUS_USEDEP
# @DESCRIPTION:
# Use it as cat/pkg[${CATKIN_MESSAGES_EUS_USEDEP}] to indicate a dependency on the EusLisp messages of cat/pkg.
CATKIN_MESSAGES_EUS_USEDEP="ros_messages_eus(-)"

# @ECLASS-VARIABLE: CATKIN_MESSAGES_NODEJS_USEDEP
# @DESCRIPTION:
# Use it as cat/pkg[${CATKIN_MESSAGES_NODEJS_USEDEP}] to indicate a dependency on the nodejs messages of cat/pkg.
CATKIN_MESSAGES_NODEJS_USEDEP="ros_messages_nodejs(-)"

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
	S=${WORKDIR}/${P}/${ROS_SUBDIR}
else
	SRC_URI="${ROS_REPO_URI}/archive/${VER_PREFIX}${PV%_*}${VER_SUFFIX}.tar.gz -> ${ROS_REPO_URI##*/}-${PV}.tar.gz"
	S=${WORKDIR}/${VER_PREFIX}${ROS_REPO_URI##*/}-${PV}${VER_SUFFIX}/${ROS_SUBDIR}
fi

HOMEPAGE="https://wiki.ros.org/${PN} ${ROS_REPO_URI}"

# @FUNCTION: ros-catkin_src_prepare
# @DESCRIPTION:
# Calls cmake_src_prepare (so that PATCHES array is handled there) and initialises the workspace
# by installing a recursive CMakeLists.txt to handle bundles.
ros-catkin_src_prepare() {
	# If no multibuild, just use cmake IN_SOURCE support
	[ -n "${CATKIN_IN_SOURCE_BUILD}" ] && export CMAKE_IN_SOURCE_BUILD=yes

	${CMAKE_ECLASS}_src_prepare

	if [ ! -f "${S}/CMakeLists.txt" ] ; then
		catkin_init_workspace || die
	fi

	# Most packages require C++11 these days. Do it here, in src_prepare so that
	# ebuilds can override it in src_configure.
	append-cxxflags '-std=c++14'
}

# @VARIABLE: mycatkincmakeargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional cmake defines as a bash array. Should be defined before calling
# src_configure.

# @FUNCTION: ros-catkin_src_configure
# @DESCRIPTION:
# Configures a catkin-based package.
ros-catkin_src_configure() {
	export CATKIN_PREFIX_PATH="${EPREFIX}/usr"
	export ROS_ROOT="${EPREFIX}/usr/share/ros"
	if [ -n "${CATKIN_HAS_MESSAGES}" ] ; then
		ROS_LANG_DISABLE=""
		use ros_messages_cxx    || ROS_LANG_DISABLE="${ROS_LANG_DISABLE}:gencpp"
		use ros_messages_eus    || ROS_LANG_DISABLE="${ROS_LANG_DISABLE}:geneus"
		use ros_messages_lisp   || ROS_LANG_DISABLE="${ROS_LANG_DISABLE}:genlisp"
		use ros_messages_python || ROS_LANG_DISABLE="${ROS_LANG_DISABLE}:genpy"
		use ros_messages_nodejs || ROS_LANG_DISABLE="${ROS_LANG_DISABLE}:gennodejs"
		export ROS_LANG_DISABLE
	fi

	local mycmakeargs=(
		"-DCATKIN_ENABLE_TESTING=$(usex test)"
		"-DCATKIN_BUILD_BINARY_PACKAGE=ON"
		"-DCATKIN_PREFIX_PATH=${SYSROOT:-${EROOT}}/usr"
		"${mycatkincmakeargs[@]}"
	)

	local sitedir="$(python_get_sitedir)"
	mycmakeargs+=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INSTALL_DIR="${sitedir#${EPREFIX}/usr/}"
	)
	if [ -n "${CATKIN_IN_SOURCE_BUILD}" ] ; then
		export CMAKE_USE_DIR="${BUILD_DIR}"
	fi

	${CMAKE_ECLASS}_src_configure "${@}"
}

# @FUNCTION: ros-catkin_src_compile
# @DESCRIPTION:
# Builds a catkin-based package.
ros-catkin_src_compile() {
	${CMAKE_ECLASS}_src_compile "${@}"
}

# @FUNCTION: ros-catkin_src_test
# @DESCRIPTION:
# Run the tests of a catkin-based package.
ros-catkin_src_test() {
	cd "${BUILD_DIR}" || die

	# Regenerate env for tests, PYTHONPATH is not set properly otherwise...
	if [ -f catkin_generated/generate_cached_setup.py ] ; then
		einfo "Regenerating setup_cached.sh for tests"
		${PYTHON:-python} catkin_generated/generate_cached_setup.py || die
	fi

	if [[ ${CMAKE_ECLASS} = cmake-utils ]]; then
		nonfatal cmake-utils_src_make tests
	else
		nonfatal cmake_build tests
	fi
	${CMAKE_ECLASS}_src_test "${@}"
}

# @FUNCTION: ros-catkin_src_install
# @DESCRIPTION:
# Installs a catkin-based package.
ros-catkin_src_install() {
	if [ -n "${CATKIN_IN_SOURCE_BUILD}" ] ; then
		export CMAKE_USE_DIR="${BUILD_DIR}"
	fi

	${CMAKE_ECLASS}_src_install "${@}"
	python_optimize
}

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
