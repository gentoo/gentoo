# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
PYTHON_COMPAT=( python3_{10..13} )
inherit ecm gear.kde.org python-single-r1

DESCRIPTION="Library for parsing and evaluating OSM opening hours expressions"
HOMEPAGE="https://api.kde.org/kopeninghours/html/index.html
https://invent.kde.org/libraries/kopeninghours"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	>=dev-libs/kpublictransport-${PVCUT}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	sys-libs/zlib
	python? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.70:=[python,${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

src_configure() {
	local mycmakeargs=(
		-DPython_LIBRARY=$(python_get_library_path)
		-DPython_INCLUDE_DIR=$(python_get_includedir)
		$(cmake_use_find_package python Boost)
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	python_optimize
}
