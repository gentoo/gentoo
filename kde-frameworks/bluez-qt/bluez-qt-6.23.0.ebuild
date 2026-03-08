# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Qt wrapper for Bluez 5 DBus API"

LICENSE="LGPL-2"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # bugs 668196, 924708; they all hang

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
RDEPEND="${DEPEND}"

src_test() {
	# parallel tests fail, bug 609248
	ecm_src_test -j1
}
