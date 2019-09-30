# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit qmake-utils

DESCRIPTION="Mission control plugin for Telepathy to provide IM accounts and authentication"
HOMEPAGE="https://01.org/gsso"
SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

DEPEND="
	dev-libs/glib:2
	net-im/telepathy-mission-control
	net-libs/libaccounts-glib
	=net-libs/libsignon-glib-1*
	net-libs/telepathy-glib
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
