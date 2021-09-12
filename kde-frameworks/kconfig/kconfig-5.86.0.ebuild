# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for reading and writing configuration"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="dbus nls"

# bug 560086
RESTRICT="test"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	dbus? ( >=dev-qt/qtdbus-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
"

DOCS=( DESIGN docs/{DESIGN.kconfig,options.md} )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonModuleGeneration=ON # bug 746866
		-DKCONFIG_USE_DBUS=$(usex dbus)
	)
	ecm_src_configure
}
