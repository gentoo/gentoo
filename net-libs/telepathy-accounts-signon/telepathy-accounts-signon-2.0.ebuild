# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Mission control plugin for Telepathy to provide IM accounts and authentication"
HOMEPAGE="https://gitlab.com/accounts-sso/telepathy-accounts-signon"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/2.0/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

BDEPEND=">=dev-util/meson-0.49.2"
DEPEND="
	dev-libs/glib:2
	net-im/telepathy-mission-control
	net-libs/libaccounts-glib:=
	>=net-libs/libsignon-glib-2.0
	net-libs/telepathy-glib
"
RDEPEND="${DEPEND}"
