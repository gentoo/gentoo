# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Kinematics and Dynamics Library (KDL)"
HOMEPAGE="https://www.orocos.org/kdl"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/orocos/orocos_kinematics_dynamics"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/orocos/orocos_kinematics_dynamics/archive/v${PV}.tar.gz -> orocos_kinematics_dynamics-${PV}.tar.gz"
	KEYWORDS="amd64 ~arm ~x86"
	S="${WORKDIR}/orocos_kinematics_dynamics-${PV}/${PN}"
fi

LICENSE="LGPL-2.1"
SLOT="0/15"
IUSE="doc examples models test"
REQUIRED_USE="examples? ( models )"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/eigen:3"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen[dot] )
	test? ( dev-util/cppunit )
"

src_configure() {
	# disable catkin support
	sed -e 's/find_package(catkin/find_package(NoTcatkin/' -i CMakeLists.txt || die
	local mycmakeargs=(
		-DBUILD_MODELS=$(usex models ON OFF)
		-DENABLE_EXAMPLES=$(usex examples)
		-DENABLE_TESTS=$(usex test)
	)
	if use examples; then
		mycmakeargs+=(
			-DBUILD_MODELS_DEMO=ON
		)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_build docs
		rm "${BUILD_DIR}/doc/kdl.tag" || die
	fi
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	eninja check
	popd > /dev/null || die
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}/doc/api/html/." )
	cmake_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r "${S}"/examples/.
	fi
}
