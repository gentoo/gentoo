# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molequeue/molequeue-0.7.1.ebuild,v 1.5 2015/08/01 17:38:42 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-single-r1 versionator virtualx

DESCRIPTION="Abstract, manage and coordinate execution of tasks"
HOMEPAGE="http://www.openchemistry.org/OpenChemistry/project/molequeue.html"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+client doc server test +zeromq"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	server? ( client )
	test? ( server )"

RDEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	zeromq? ( net-libs/cppzmq:0= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use_use zeromq ZERO_MQ)
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use client MoleQueue_BUILD_CLIENT)
		$(cmake-utils_use server MoleQueue_BUILD_APPLICATION)
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
	use doc && HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	cmake-utils_src_install
}
