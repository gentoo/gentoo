# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_7,3_8,3_9} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/orocos/orocos_kinematics_dynamics"
fi

inherit ${SCM} python-r1 cmake

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/orocos/orocos_kinematics_dynamics/archive/v${PV}.tar.gz -> orocos_kinematics_dynamics-${PV}.tar.gz"
fi

DESCRIPTION="Python bindings for KDL"
HOMEPAGE="https://www.orocos.org/kdl"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=sci-libs/orocos_kdl-1.4.0:=
	<dev-python/sip-5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/0001-Declare-assignment-operator-private-for-SIP-Closes-2.patch" )

if [ "${PV#9999}" != "${PV}" ] ; then
	S=${WORKDIR}/${P}/python_orocos_kdl
else
	S=${WORKDIR}/orocos_kinematics_dynamics-${PV}/python_orocos_kdl
fi

src_configure() {
	python_foreach_impl cmake_src_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	python_foreach_impl cmake_src_test
}

src_install() {
	python_foreach_impl cmake_src_install

	# Need to have package.xml in our custom gentoo path
	insinto /usr/share/ros_packages/${PN}
	doins "${ED}/usr/share/${PN}/package.xml"
}
