# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/orocos/orocos_kinematics_dynamics"
fi

inherit ${SCM} cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/orocos/orocos_kinematics_dynamics/archive/v${PV}.tar.gz -> orocos_kinematics_dynamics-${PV}.tar.gz"
fi

DESCRIPTION="Kinematics and Dynamics Library (KDL)"
HOMEPAGE="http://www.orocos.org/kdl"
LICENSE="LGPL-2.1"
SLOT="0/14"
IUSE="doc test examples models"

RDEPEND="dev-cpp/eigen:3"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )
	doc? ( app-doc/doxygen )"
REQUIRED_USE="examples? ( models )"

DOCS=( README )

if [ "${PV#9999}" != "${PV}" ] ; then
	S=${WORKDIR}/${P}/orocos_kdl
else
	S=${WORKDIR}/orocos_kinematics_dynamics-${PV}/orocos_kdl
fi

src_configure() {
	local mycmakeargs=(
		"$(cmake-utils_use_enable test TESTS)"
		"$(cmake-utils_use_enable examples EXAMPLES)"
		"-DBUILD_MODELS=$(usex models ON OFF)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cd "${BUILD_DIR}"
	use doc && emake docs
}

src_test() {
	cd "${BUILD_DIR}"
	emake check
}

src_install() {
	cmake-utils_src_install
	cd "${BUILD_DIR}"
	use doc && dohtml -r doc/api/html/*
	use examples && dobin "${BUILD_DIR}/examples/"{geometry,trajectory_example,chainiksolverpos_lma_demo}

	# Need to have package.xml in our custom gentoo path
	insinto /usr/share/ros_packages/${PN}
	doins "${ED}/usr/share/${PN}/package.xml"
}
