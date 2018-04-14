# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit kde5 python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(add_qt_dep qtscript)
	sys-devel/gettext
	virtual/libintl
"
DEPEND="${RDEPEND}
	test? (
		$(add_qt_dep qtconcurrent)
		$(add_qt_dep qtdeclarative)
	)
"

pkg_setup() {
	kde5_pkg_setup
	python-single-r1_pkg_setup
}
