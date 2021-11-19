# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
QTMIN=5.15.2
inherit ecm kde.org python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-qt/qtdeclarative-${QTMIN}:5
	sys-devel/gettext
	virtual/libintl
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	app-text/iso-codes
"

PATCHES=( "${FILESDIR}/${PN}-5.57.0-python.patch" )

pkg_setup() {
	ecm_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonModuleGeneration=ON # bug 746866
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	ecm_src_configure
}

src_test() {
	# requires LANG fr_CH. bug 823816
	local myctestargs=( -E "(kcountrytest|kcountrysubdivisiontest)" )
	ecm_src_test
}
