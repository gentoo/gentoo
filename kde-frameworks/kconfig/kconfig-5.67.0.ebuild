# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for reading and writing configuration"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="dbus nls"

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

# bug 560086
RESTRICT+=" test"

DOCS=( DESIGN docs/DESIGN.kconfig docs/options.md )

src_configure() {
	local mycmakeargs=(
		-DKCONFIG_USE_DBUS=$(usex dbus)
	)
	ecm_src_configure
}
