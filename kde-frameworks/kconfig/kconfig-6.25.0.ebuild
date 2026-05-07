# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for reading and writing configuration"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="dbus qml"
REQUIRED_USE="test? ( qml )"

# bug 560086
RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus?,gui,xml]
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[concurrent] )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

DOCS=( DESIGN docs/{DESIGN.kconfig,options.md} )

src_configure() {
	local mycmakeargs=(
		-DUSE_DBUS=$(usex dbus)
		-DKCONFIG_USE_QML=$(usex qml)
	)
	ecm_src_configure
}
