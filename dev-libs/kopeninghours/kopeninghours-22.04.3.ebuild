# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.92.0
QTMIN=5.15.4
PYTHON_COMPAT=( python3_{8..11} )
inherit ecm gear.kde.org python-single-r1

DESCRIPTION="Library for parsing and evaluating OSM opening hours expressions"
HOMEPAGE="https://api.kde.org/kopeninghours/html/index.html
https://invent.kde.org/libraries/kopeninghours"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	>=dev-libs/kpublictransport-${PVCUT}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=kde-frameworks/kholidays-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	sys-libs/zlib
	python? (
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

PATCHES=( "${FILESDIR}"/${PN}-22.04.0-boostpython.patch )

pkg_setup() {
	ecm_pkg_setup
	python_setup
}

src_configure() {
	local mycmakeargs=(
		-DBOOSTPYTHON_VERSION_MAJOR_MINOR=${EPYTHON}
		$(cmake_use_find_package python Boost)
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	python_optimize
}
