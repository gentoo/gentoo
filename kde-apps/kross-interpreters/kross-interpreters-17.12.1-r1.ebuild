# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
USE_RUBY="ruby23"
inherit kde5 python-single-r1 ruby-single

DESCRIPTION="Kross interpreter plugins for programming languages"
KEYWORDS="~amd64 ~x86"
IUSE="+python ruby"

REQUIRED_USE="|| ( python ruby ) python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	$(add_frameworks_dep kross)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	kde5_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_python=$(usex python)
		-DBUILD_ruby=$(usex ruby)
	)

	kde5_src_configure
}
