# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ros-catkin.eclass
# @MAINTAINER:
# ros@gentoo.org
# @AUTHOR:
# Alexis Ballier <aballier@gentoo.org>
# @BLURB: Template eclass for catkin based ROS packages.
# @DESCRIPTION:
# Provides function for building ROS packages on Gentoo.
# It supports selectively building messages, multi-python installation, live ebuilds (git only).

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "EAPI='${EAPI}' is not supported"
		;;
	*)
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

# This should be temporary. ROS only really works with one global python
# version. The idea here is to have a ROS_COMPAT in the same vein as
# PYTHON_COMPAT where packages would define what distro they can work on, then
# we'd have ros_distro_gentoo_python_2_7 & co plus the OSRF ones (lunar, etc.).
# Note that this uncondtionally pulls python but in the ROS world there will
# most certainly be something pulling python anyway.
PYTHON_COMPAT=( python2_7 )

inherit ${SCM} python-r1 cmake-utils flag-o-matic

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

IUSE="test"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-util/catkin[${PYTHON_USEDEP}]
	dev-python/empy[${PYTHON_USEDEP}]
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
		ros_messages_cxx?    ( dev-ros/gencpp:=    dev-ros/gencpp[${PYTHON_USEDEP}]    )
		ros_messages_eus?    ( dev-ros/geneus:=    dev-ros/geneus[${PYTHON_USEDEP}]    )
		ros_messages_python? ( dev-ros/genpy:=     dev-ros/genpy[${PYTHON_USEDEP}]     )
		ros_messages_lisp?   ( dev-ros/genlisp:=   dev-ros/genlisp[${PYTHON_USEDEP}]   )
		ros_messages_nodejs? ( dev-ros/gennodejs:= dev-ros/gennodejs[${PYTHON_USEDEP}] )
		dev-ros/message_runtime
	"
	DEPEND="${DEPEND} ${RDEPEND}
		dev-ros/message_generation
		dev-ros/genmsg[${PYTHON_USEDEP}]
	"
	if [ -n "${CATKIN_MESSAGES_TRANSITIVE_DEPS}" ] ; then
		for i in ${CATKIN_MESSAGES_TRANSITIVE_DEPS} ; do
			ds="${i}[ros_messages_python(-)?,ros_messages_cxx(-)?,ros_messages_lisp(-)?,ros_messages_eus(-)?,ros_messages_nodejs(-)?] ros_messages_python? ( ${i}[${PYTHON_USEDEP}] )"
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
CATKIN_MESSAGES_PYTHON_USEDEP="ros_messages_python(-),${PYTHON_USEDEP}"

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

HOMEPAGE="http://wiki.ros.org/${PN}"

# @FUNCTION: ros-catkin_src_prepare
# @DESCRIPTION:
# Calls cmake-utils_src_prepare (so that PATCHES array is handled there) and initialises the workspace
# by installing a recursive CMakeLists.txt to handle bundles.
ros-catkin_src_prepare() {
	# If no multibuild, just use cmake IN_SOURCE support
	[ -n "${CATKIN_IN_SOURCE_BUILD}" ] && export CMAKE_IN_SOURCE_BUILD=yes

	cmake-utils_src_prepare

	if [ ! -f "${S}/CMakeLists.txt" ] ; then
		catkin_init_workspace || die
	fi

	# Most packages require C++11 these days. Do it here, in src_prepare so that
	# ebuilds can override it in src_configure.
	append-cxxflags '-std=c++11'
}

# @FUNCTION: ros-catkin_python_setup
# @DESCRIPTION:
# Sets up python environment for ROS packages.
ros-catkin_python_setup() {
	# Todo: Need to match this with ros distro.
	local pyimpl="${PYTHON_COMPAT[0]}"
	python_export "${pyimpl}" EPYTHON PYTHON
	python_wrapper_setup
	python_export PYTHON_SCRIPTDIR
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
	ros-catkin_python_setup

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
		"$(cmake-utils_use test CATKIN_ENABLE_TESTING)"
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

	cmake-utils_src_configure "${@}"
}

# @FUNCTION: ros-catkin_src_compile
# @DESCRIPTION:
# Builds a catkin-based package.
ros-catkin_src_compile() {
	ros-catkin_python_setup
	cmake-utils_src_compile "${@}"
}

# @FUNCTION: ros-catkin_src_test
# @DESCRIPTION:
# Run the tests of a catkin-based package.
ros-catkin_src_test() {
	cd "${BUILD_DIR}" || die

	ros-catkin_python_setup

	# Regenerate env for tests, PYTHONPATH is not set properly otherwise...
	if [ -f catkin_generated/generate_cached_setup.py ] ; then
		einfo "Regenerating setup_cached.sh for tests"
		${PYTHON:-python} catkin_generated/generate_cached_setup.py || die
	fi
	# Using cmake-utils_src_make with nonfatal does not work and breaks e.g.
	# dev-ros/rviz.
	if nonfatal emake tests -n &> /dev/null ; then
		cmake-utils_src_make tests
	fi
	cmake-utils_src_test "${@}"
}

# @FUNCTION: ros-catkin_src_install
# @DESCRIPTION:
# Installs a catkin-based package.
ros-catkin_src_install() {
	ros-catkin_python_setup

	if [ -n "${CATKIN_IN_SOURCE_BUILD}" ] ; then
		export CMAKE_USE_DIR="${BUILD_DIR}"
	fi

	cmake-utils_src_install "${@}"
	if [ ! -f "${T}/.catkin_python_symlinks_generated" -a -d "${D}/${PYTHON_SCRIPTDIR}" ]; then
		dodir /usr/bin
		for i in "${D}/${PYTHON_SCRIPTDIR}"/* ; do
			dosym ../lib/python-exec/python-exec2 "/usr/bin/${i##*/}"
		done
		touch "${T}/.catkin_python_symlinks_generated" || die
	fi
}

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
