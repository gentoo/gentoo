# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )
inherit kde5 python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(add_qt_dep qtscript)
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

src_install() {
	kde5_src_install
	python_fix_shebang "${D}/usr/$(get_libdir)/cmake/KF5I18n/ts-pmap-compile.py"
}
