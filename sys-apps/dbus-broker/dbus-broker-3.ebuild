# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"
SRC_URI="https://github.com/bus1/dbus-broker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/c-dvar-1
	>=dev-libs/c-rbtree-2
	>=dev-libs/expat-2.2
	>=dev-libs/glib-2.50:2
	>=sys-apps/systemd-230
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}
	>=dev-libs/c-list-2
	>=dev-libs/c-sundry-1
	virtual/pkgconfig
	test? ( >=sys-apps/dbus-1.10 )
"
