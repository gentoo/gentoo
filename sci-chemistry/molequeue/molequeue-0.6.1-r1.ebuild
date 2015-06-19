# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molequeue/molequeue-0.6.1-r1.ebuild,v 1.2 2015/04/08 18:22:13 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-single-r1 versionator

DESCRIPTION="Abstract, manage and coordinate execution of tasks"
HOMEPAGE="http://www.openchemistry.org/OpenChemistry/project/molequeue.html"
SRC_URI="http://openchemistry.org/files/v$(get_version_component_range 1-2)/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test +zeromq"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	zeromq? ( net-libs/cppzmq )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e 's:@LIB_SUFFIX@::g' \
		-i cmake/MoleQueueConfig.cmake.in || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use_use zeromq ZERO_MQ)
		-DINSTALL_LIBRARY_DIR=$(get_libdir)
		)
	use zeromq && \
		mycmakeargs+=( -DZeroMQ_ROOT_DIR=\"${EPREFIX}/usr\" )

	cmake-utils_src_configure
}
