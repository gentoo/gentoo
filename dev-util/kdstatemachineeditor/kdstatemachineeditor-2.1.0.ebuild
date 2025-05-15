# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="KDStateMachineEditor"

DESCRIPTION="Framework for creating Qt State Machine metacode using graphical user interfaces"
HOMEPAGE="https://github.com/KDAB/KDStateMachineEditor"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDAB/KDStateMachineEditor.git"
else
	SRC_URI="https://github.com/KDAB/KDStateMachineEditor/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc gui test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[gui,network,opengl,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtremoteobjects:6
	dev-qt/qtscxml:6
	media-gfx/graphviz
	gui? ( dev-qt/qt5compat:6[qml] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-qt/qttools:6[assistant]
	)
	gui? ( dev-util/patchelf )
"

src_prepare() {
	# set TEST_DATA_DIR for application env instead of test env.
	if use gui; then
		sed -e 's:${CMAKE_CURRENT_SOURCE_DIR}/data:'"${EPREFIX}"'/usr/share/'"${PN}"'/data:' \
			-i CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DKDSME_DOCS=$(usex doc)
		-DKDSME_EXAMPLES=OFF
		-DKDSME_INTERNAL_GRAPHVIZ=OFF
	)

	use doc && mycmakeargs+=(
		# prevent ${PF}-qt6
		-DQCH_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}/"
	)

	if use gui || use test; then
		mycmakeargs+=( -DBUILD_TESTING=ON )
	else
		mycmakeargs+=( -DBUILD_TESTING=OFF )
	fi

	cmake_src_configure
}

src_test() {
	# skip tests that use scxml files in modified TEST_DATA_DIR
	use gui && CMAKE_SKIP_TESTS=(
		test_layouter
		test_scxmlimport
	)
	local -x QT_QPA_PLATFORM=offscreen
	KDE_DEBUG=1 cmake_src_test
}

src_install() {
	cmake_src_install

	rm "${ED}"/usr/$(get_libdir)/*.a || die

	if use gui; then
		patchelf --remove-rpath "${BUILD_DIR}"/bin/${PN} || die
		dobin "${BUILD_DIR}"/bin/${PN}
		mkdir -p "${ED}"/usr/share/${PN} || die
		cp -R data "${ED}"/usr/share/${PN}/ || die
	fi

	use doc && docompress -x /usr/share/doc/${PF}/${PN}{-api.qch,.tags}
}
