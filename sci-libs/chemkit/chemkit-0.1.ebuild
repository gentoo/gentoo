# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-single-r1 virtualx

DESCRIPTION="Library for chemistry applications"
HOMEPAGE="http://www.chemkit.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="applications examples python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( applications python )"

RDEPEND="
	dev-libs/boost
	dev-cpp/eigen:3
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	media-libs/glu
	examples? (
		x11-libs/libX11
		x11-libs/libXext
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	)

src_configure() {
	local mycmakeargs=(
		-DCHEMKIT_BUILD_PLUGIN_BABEL=on
		$(cmake-utils_use applications CHEMKIT_BUILD_APPS)
		$(cmake-utils_use applications CHEMKIT_BUILD_QT_DESIGNER_PLUGINS)
		$(cmake-utils_use examples CHEMKIT_BUILD_EXAMPLES)
		$(cmake-utils_use examples CHEMKIT_BUILD_DEMOS)
		$(cmake-utils_use python CHEMKIT_BUILD_BINDINGS_PYTHON)
		$(cmake-utils_use test CHEMKIT_BUILD_TESTS)
	)
	cmake-utils_src_configure
}

src_test() {
	VIRTUALX_COMMAND="cmake-utils_src_test"
	virtualmake
}

src_install() {
	use examples && dobin demos/*-viewer/*-viewer examples/uff-energy/uff-energy

	cmake-utils_src_install
}
