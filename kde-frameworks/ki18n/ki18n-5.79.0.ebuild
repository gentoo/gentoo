# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
QTMIN=5.15.2
inherit ecm kde.org python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-qt/qtdeclarative-${QTMIN}:5
	sys-devel/gettext
	virtual/libintl
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
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
