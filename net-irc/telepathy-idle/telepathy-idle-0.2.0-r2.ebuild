# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Full-featured IRC connection manager for Telepathy"
HOMEPAGE="https://cgit.freedesktop.org/telepathy/telepathy-idle"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	virtual/pkgconfig
	test? ( dev-python/twisted-words )
"
RDEPEND="
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/glib-2.32:2
	>=net-libs/telepathy-glib-0.21
	sys-apps/dbus
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fixes.patch"
)

src_prepare() {
	default

	# Failed in 0.1.16 and code has not moved since october
	# Upstream is working on 1.0
	sed -e 's:connect/server-quit-ignore.py::' \
		-e 's:connect/server-quit-noclose.py::' \
		-i tests/twisted/Makefile.{am,in} || die
}
