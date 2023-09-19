# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-r1 virtualx

DESCRIPTION="Abstract, manage and coordinate execution of tasks"
HOMEPAGE="https://www.openchemistry.org/projects/molequeue/"
SRC_URI="https://github.com/OpenChemistry/molequeue/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="+client doc server test +zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	server? ( client )
	test? ( server )
	zeromq? ( ${PYTHON_REQUIRED_USE} )
"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	zeromq? (
		${PYTHON_DEPS}
		net-libs/cppzmq:0=
	)
"
DEPEND="${RDEPEND}"

# Some tests still fail
RESTRICT="test"

src_configure() {
	configuration() {
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
			mycmakeargs+=( "-DZeroMQ_ROOT_DIR=\"${EPREFIX}/usr\"" )

		cmake_src_configure
	}
	if use zeromq; then
		python_foreach_impl run_in_build_dir configuration
	else
		configuration
	fi
}

src_compile() {
	if use zeromq; then
		my_src_compile() {
			run_in_build_dir cmake_src_compile all $(usex doc documentation "")
			use doc && export HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
		}
		python_foreach_impl my_src_compile
	else
		cmake_src_compile all $(usex doc documentation "")
		use doc && export HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	fi
}

src_test() {
	if use zeromq; then
		python_foreach_impl run_in_build_dir virtx cmake_src_test
	else
		virtx cmake_src_test
	fi
}

src_install() {
	if use zeromq; then
		python_foreach_impl run_in_build_dir cmake_src_install
		python_foreach_impl run_in_build_dir python_optimize
	else
		cmake_src_install
	fi
}
