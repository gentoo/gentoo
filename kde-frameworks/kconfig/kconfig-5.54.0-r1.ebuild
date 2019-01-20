# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for reading and writing configuration"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="dbus nls"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtxml)
	dbus? ( $(add_qt_dep qtdbus) )
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
	test? ( $(add_qt_dep qtconcurrent) )
"

# bug 560086
RESTRICT+=" test"

DOCS=( DESIGN docs/DESIGN.kconfig docs/options.md )

src_configure() {
	local mycmakeargs=(
		-DKCONFIG_USE_DBUS=$(usex dbus)
	)
	kde5_src_configure
}
