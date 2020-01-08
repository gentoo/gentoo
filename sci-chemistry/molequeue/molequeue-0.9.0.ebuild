# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 virtualx

DESCRIPTION="Abstract, manage and coordinate execution of tasks"
HOMEPAGE="https://www.openchemistry.org/projects/molequeue/"
SRC_URI="https://github.com/OpenChemistry/molequeue/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+client doc server test +zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	server? ( client )
	test? ( server )"

BDEPEND="
	doc? ( app-doc/doxygen )"
RDEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	zeromq? ( net-libs/cppzmq:0= )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-qt-5.11b3.patch )

src_configure() {
	local mycmakeargs=(
		-DMoleQueue_USE_EZHPC_UIT=OFF
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DMoleQueue_BUILD_CLIENT=$(usex client)
		-DMoleQueue_BUILD_APPLICATION=$(usex server)
		-DENABLE_TESTING=$(usex test)
		-DUSE_ZERO_MQ=$(usex zeromq)
		-DINSTALL_LIBRARY_DIR=$(get_libdir)
	)
	use zeromq && \
		mycmakeargs+=( -DZeroMQ_ROOT_DIR=\"${EPREFIX}/usr\" )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usex doc documentation "")
}

src_test() {
	VIRTUALX_COMMAND=cmake-utils_src_test
	virtualmake
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	cmake-utils_src_install
}
