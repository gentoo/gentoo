# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit python-single-r1

DESCRIPTION="Full-featured IRC connection manager for Telepathy"
HOMEPAGE="https://gitlab.freedesktop.org/telepathy/telepathy-idle"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/glib-2.32:2
	>=net-libs/telepathy-glib-0.21
	sys-apps/dbus
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"
