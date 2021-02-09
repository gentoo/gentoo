# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage Qt for Python implementations"
HOMEPAGE="https://github.com/spyder-ide/qtpy"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="app-admin/eselect"

S="${FILESDIR}"

src_install() {
	insinto "/usr/share/eselect/modules"
	newins "qtpy.eselect-${PV}" "qtpy.eselect"
}

pkg_postinst() {
	eselect qtpy update
}
