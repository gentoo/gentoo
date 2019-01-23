# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )
inherit kde5 python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(add_qt_dep qtdeclarative)
	sys-devel/gettext
	virtual/libintl
"
DEPEND="${RDEPEND}
	test? ( $(add_qt_dep qtconcurrent) )
"

pkg_setup() {
	kde5_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	kde5_src_configure
}
